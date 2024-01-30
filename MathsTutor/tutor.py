###########################################################################
#    Maths-Tutor
#
#    Copyright (C) 2022-2023 Roopasree A P <roopasreeap@gmail.com>    
#    Copyright (C) 2023-2024 Greeshna Sarath <greeshnamohan001@gmail.com>
#    Copyright (C) 2024-2025 Nalin Sathyan <nalin.x.linux@gmail.com>
#
#    This project is Supervised by Zendalona(2022-2023)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
###########################################################################


import gi
import time
gi.require_version("Gtk", "3.0")
gi.require_version('Gst', '1.0')
from gi.repository import Gtk, Gdk, GObject, GLib,Pango

from MathsTutor import global_var

# Import GST
from gi.repository import Gst
import re
import os
import threading
import math
import random

listing_symbol = ","
range_symbol = ":"
multiplier_symbol = ";"

class MathsTutorBin(Gtk.Bin):
    def __init__(self, speech_object, gettext):
        Gtk.Bin.__init__(self)
        self.set_border_width(10)

        self.speech = speech_object

        global _;
        _ = gettext

        # initialize Gstreamer
        Gst.init(None)

        #Create a vertical box layout
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)

        vbox2 = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        
        # Add the VBox container to the main window
        self.add(vbox)
        
        self.welcome_message = _("Welcome!")+" "+_("Press enter to start")
        
        """An appreciation dictionary is used here to help non-English
        translators understand things more easily. Also, there is not
        always a one-to-one word correspondence in every language."""
        self.appreciation_dict = {
        "Excellent" : [ _('Excellent-1'), _('Excellent-2'), _('Excellent-3'), _('Excellent-4'), _('Excellent-5')],
        "Very good" : [_('Very good-1'), _('Very good-2'), _('Very good-3'), _('Very good-4'), _('Very good-5')],
        "Good" : [_('Good-1'), _('Good-2'), _('Good-3'), _('Good-4'), _('Good-5')],
        "Fair" : [_('Fair-1'), _('Fair-2'), _('Fair-3'), _('Fair-4'), _('Fair-5')],
        "Okay" : [_('Okay-1'), _('Okay-2'), _('Okay-3'), _('Okay-4'), _('Okay-5')]
        }
        
        # create  a Gtk label
        self.label = Gtk.Label()
        
        # Modify the font of the label
        vbox2.modify_font(Pango.FontDescription("Sans 40"))
        
        # Modification of background and font color is disabled because
        # the message is not visible in some system themes.
        #font_color = "#0603f0"
        #background_color = "#ffffff"
        #vbox2.modify_fg(Gtk.StateFlags.NORMAL, Gdk.color_parse(font_color))
        #vbox2.modify_bg(Gtk.StateFlags.NORMAL, Gdk.color_parse(background_color))
        
        # Add the label to the vbox container
        vbox2.pack_start(self.label, True, True, 0)
        
        
        #Create a horizontal box layout 
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=5)

        fix1 = Gtk.Fixed()
        hbox.pack_start(fix1, True, True, 0)
        
        #Add the hbox to the vbox container
        vbox2.pack_start(hbox, False, False, 0)

       
        #Create a Gtk.Entry widget and assign it to self.entry
        self.entry = Gtk.Entry()
        
        # Connect the "activate" signal of the entry widget to the self.on_entry_activated method
        self.entry.connect("activate", self.on_entry_activated)
        self.entry.connect("key-press-event", self.on_key_press)
        
        #Add entry to horizontal box
        hbox.pack_start(self.entry, False, False, 0)

        fix2 = Gtk.Fixed()
        hbox.pack_start(fix2, True, True, 0)
        
        
        #Create multiple instances of GtkImage and add them to the vertical box
        self.image = Gtk.Image()
        vbox2.pack_start(self.image, True, True, 0)

        vbox.pack_start(vbox2, True, True, 0)
        
        self.current_question_index = -1
        self.wrong=False
        self.current_performance_rate=0
        self.final_score=0
        self.incorrect_answer_count=0
        self.number_of_questions_attended = 0
        
        
        # Create a playbin element with the name 'player' and assign it to self.player
        self.player = Gst.ElementFactory.make('playbin', 'player')

    def grab_focus_on_entry(self):
        self.entry.grab_focus()

    def connect_game_over_callback_function(self, function):
        self.game_over_callback_function = function


    #Function to play sounds
    def play_file(self, name, rand_range=1):
        if(rand_range == 1):
            file_path_and_name = 'file:///'+global_var.data_dir+'/sounds/'+name+".ogg";
        else:
            value = str(random.randint(1, rand_range))
            file_path_and_name = 'file:///'+global_var.data_dir+'/sounds/'+name+"-"+value+".ogg";
        self.player.set_state(Gst.State.READY)
        self.player.set_property('uri',file_path_and_name)
        self.player.set_state(Gst.State.PLAYING)
    
    
    #Function to set image from file 
    def set_image(self, name, rand_range):
	    value = str(random.randint(1, rand_range))
	    self.image.set_from_file(global_var.data_dir+"/images/"+name+"-"+value+".gif");

    def speak(self, text, enqueue=False):
        if(enqueue == False):
            self.speech.cancel();
        self.speech.speak(text)
   
    #Function to read the questions from the file
    def load_question_file(self, file_path):
        # Resetting all game variables
        self.list = []
        self.current_question_index = -1
        self.wrong=False
        self.number_of_questions_attended = 0

        # Loading questions from file
        with open(file_path, "r") as file:
            for line in file:
                stripped_line = line.strip()
                self.list.append(stripped_line)

        # Set the text of the label to the value of welcome_message
        self.label.set_text(self.welcome_message)

        self.set_image("welcome", 3)

        # Playing starting sound
        self.play_file('welcome')

        self.speak(self.welcome_message)

        self.entry.grab_focus()

        self.game_over = False

    
    # Function to covert the signs to text
    def convert_signs(self, text):
        return text.replace("+", " " + _("plus") + " ") \
                   .replace("-", " " + _("minus") + " ") \
                   .replace("*", " " + _("multiply") + " ") \
                   .replace("/", " " + _("divided by") + " ") \
                   .replace("%", " " + _("percentage of") + " ")

    def convert_to_verbose(self, text):
        return ", ".join(text)


    def on_key_press(self, widget, event):
        keyval = event.keyval
        if (keyval == 32): # Space
           self.announce_question_using_thread()
           return True
        elif keyval in (65505, 65506): #Shift
           self.announce_question_using_thread(True)
           return True
        elif (keyval == 59): # Semicolon
           self.speech.set_speech_rate(int(self.speech.get_speech_rate())-10)
           self.announce_question_using_thread()
           return True
        elif (event.keyval == 39): # Apostrophe
           self.speech.set_speech_rate(int(self.speech.get_speech_rate())+10)
           self.announce_question_using_thread()
           return True

    # Function to display the question and corresponding images and sounds
    def on_entry_activated(self,entry):
        if (self.game_over):
            self.game_over_callback_function()
        elif (self.current_question_index == -1):
            self.starting_time = time.time();
            self.wrong=False
            self.current_performance_rate=0
            self.final_score=0
            self.incorrect_answer_count=0
            self.next_question()
        else:
            answer = self.entry.get_text()
            correct_answer = self.answer
            
            if answer == correct_answer:                
                time_end = time.time()

                time_taken = time_end - self.time_start

                time_alotted = int(self.list[self.current_question_index].split("===")[1])

                print(
                    f"\n### Time Allotted ###\n"
                    f"Excellent: {time_alotted - (time_alotted * 50) / 100}\n"
                    f"Very Good: {time_alotted - (time_alotted * 25) / 100}\n"
                    f"Good: {time_alotted}\n"
                    f"Fair: {time_alotted + (time_alotted * 25) / 100}\n"
                    f"### Time Taken: {time_taken}\n\n"
                    )

                self.incorrect_answer_count=0

                appreciation_index = random.randint(0,4)

                if  time_taken < time_alotted - ((time_alotted*50)/100):
                    self.current_performance_rate += 4
                    self.final_score += 50
                    text = self.appreciation_dict["Excellent"][appreciation_index]
                    self.set_image("excellent", 3)
                    self.play_file("excellent", 3)
                elif time_taken < time_alotted - ((time_alotted*25)/100):
                    self.current_performance_rate += 2
                    self.final_score += 40
                    text = self.appreciation_dict["Very good"][appreciation_index]
                    self.set_image("very-good", 3)
                    self.play_file("very-good", 3)
                elif time_taken < time_alotted:
                    self.current_performance_rate += 1
                    self.final_score += 30
                    text = self.appreciation_dict["Good"][appreciation_index]
                    self.set_image("good", 3)
                    self.play_file("good", 3)
                elif time_taken < time_alotted + ((time_alotted*25)/100):
                    # No changes to self.current_performance_rate
                    self.final_score += 20
                    text = self.appreciation_dict["Fair"][appreciation_index]
                    self.set_image("not-bad", 3)
                    self.play_file('not-bad', 3)
                    
                else :
                    self.current_performance_rate -= 1
                    self.final_score += 10
                    text = self.appreciation_dict["Okay"][appreciation_index]
                    self.set_image("okay", 3)
                    self.play_file('okay', 3)
                text = text + "!"
                self.speak(text)
                self.label.set_text(text)

            else:
                self.wrong=True
                self.current_performance_rate -= 3
                self.final_score -= 10
                self.incorrect_answer_count=self.incorrect_answer_count+1
                if self.incorrect_answer_count==3:
                    self.set_image("wrong-anwser-repeted", 2)
                    self.play_file("wrong-anwser-repeted", 3)
                    self.incorrect_answer_count = 0
                    text = _("Sorry! The correct answer is ")
                    self.label.set_text(text+self.answer)
                    if(len(self.answer.split(".")) > 1):
                        li = list(self.answer.split(".")[1])
                        self.speak(text+self.answer.split(".")[0]+" "+_("point")+" "+" ".join(li))
                    else:
                        self.speak(text+self.answer)
                    
                else :
                    text = _("Sorry! Let's try again")
                    self.label.set_text(text)
                    self.speak(text)
                    self.set_image("wrong-anwser", 3)
                    self.play_file("wrong-anwser", 3)
            GLib.timeout_add_seconds(3,self.next_question)
            self.entry.set_text("")
            
    
    # Function to set next question        
    def next_question(self):
        self.time_start = time.time()
        self.entry.grab_focus()

        if self.wrong==True:
            self.label.set_text(self.question)
            self.announce_question_using_thread()
            self.set_image("wrong-anwser", 3)
            self.wrong=False
        else:
            print("Current Performance Rate = "+str(self.current_performance_rate)+
            " Question index shift = " + str(math.floor(self.current_performance_rate/10)+1))
            next_question = self.current_question_index + math.floor(self.current_performance_rate/10)+1;
            if(next_question >= 0):
                self.current_question_index = next_question

            if self.current_question_index < len(self.list)-1:
                question_to_pass = self.list[self.current_question_index].split("===")[0]
                self.question = self.make_question(question_to_pass)
                question_to_evaluate = self.question
                if("%" in self.question):
                    digit_one, digit_two = self.question.split("%")
                    question_to_evaluate = "("+digit_one+"*"+digit_two+")/100"

                number = eval(question_to_evaluate)
                if number==math.trunc(number):
                    self.answer = str(math.trunc(number))
                else:
                    num= round(eval(str(number)),2)
                    self.answer = str(num)

                self.make_sound = self.list[self.current_question_index].split("===")[2]
                self.label.set_text(self.question)                
                self.announce_question_using_thread()
                
                self.entry.set_text("")
                self.set_image("question", 2)

                self.number_of_questions_attended += 1

            else:
                minute, seconds = divmod(round(time.time()-self.starting_time), 60)
                score = round((self.final_score*100)/(50*self.number_of_questions_attended))
                text = _("Successfully finished! Your mark is ")+str(score)+\
                "!\n"+_("Time taken ")+str(minute)+" "+_("minutes and")+" "+str(seconds)+" "+_("seconds!");
                self.speak(text)
                self.label.set_text(text)
                self.set_image("finished", 3)
                self.play_file("finished", 3)
                self.game_over = True
                
                

    # Create random numbers
    def get_randome_number(self, value1, value2):
        if(int(value1) < int(value2)):
            return str(random.randint(int(value1),int(value2)))
        else:
            return str(random.randint(int(value2),int(value1)))


    """
    Question maker for creating questions by randomly selecting an operand
    from a list of numbers separated by a listing_symbol, or a number between
    two numbers separated by a range_symbol, or multiples of a number from
    range start to end separated by a multiplier_symbol.
    """
    def make_question(self, question):
        # adding $ symbol to notify end
        question = question + "$"
        output = ""
        start = 0
        for i in range(0, len(question)):
            item = question[i]

            if(item.isdigit() or item == listing_symbol or item == range_symbol or item == multiplier_symbol or item == "."):
                pass
            else:
                number_content = question[start:i]
                start = i+1

                if(listing_symbol in number_content):
                    number_list = number_content.split(listing_symbol)
                    selected = number_list[random.randint(0,len(number_list)-1)]
                    output = output + str(selected) + item

                elif (range_symbol in number_content):
                    digit_one, digit_two = number_content.split(range_symbol)
                    selected = self.get_randome_number(digit_one, digit_two)
                    output = output + str(selected) + item

                elif (multiplier_symbol in number_content):
                    digit, num_start, num_end = number_content.split(multiplier_symbol)
                    num = random.randint(int(num_start),int(num_end))
                    selected = int(digit)*num;
                    output = output + str(selected) + item

                else:
                    output = output + str(number_content) + item

        # [:-1] for removing $ symbol before returning
        return output[:-1]

    def announce_question_using_thread(self, verbose=False):
        try:
           threading.Thread(target=self.announce_question,args=[self.question,
            self.make_sound, self.current_question_index, verbose]).start()
        except AttributeError:
           self.speak(_("Press enter to start"))
    
    # Function for announcing a question with or without a bell sound.
    def announce_question(self, question, make_sound, announcing_question_index, verbose):
        if(make_sound == '1'):
            item_list = re.split(r'(\d+)', question)[1:-1]

            if(self.question == self.answer):
                self.speak(_("Enter the number of bells rung!"))
                time.sleep(1.8)

            for item in item_list:
                # To prevent announcement on user answer
                if(announcing_question_index != self.current_question_index):
                    return;
                if item.isnumeric():

                    num = int(item)
                    while(num > 0):
                        num = num-1;
                        self.play_file("coin")
                        time.sleep(0.7)
                else:
                    self.speak(self.convert_signs(item))
                    time.sleep(0.7)
            if(announcing_question_index != self.current_question_index):
                self.speak(_("equals to?"))
        else:
            self.play_file("question")
            time.sleep(0.7)
            if(verbose):
                if(self.question == self.answer):
                    self.speak(_("Enter ")+self.convert_to_verbose(self.answer))
                else:
                    self.speak(self.convert_signs(self.convert_to_verbose(self.question))+" "+_("equals to?"))
            else:
                if(self.question == self.answer):
                    self.speak(_("Enter ")+self.answer)
                else:
                    self.speak(self.convert_signs(self.question)+" "+_("equals to?"))

    def on_quit(self):
        pass

if __name__ == "__main__":
    win = MathsTutorWindow()
