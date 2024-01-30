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

import speechd

espeak_ng_alternative_dict = {"en":"en-US"}

class Speech(speechd.SSIPClient):
    def __init__(self,client_name="Maths-Tutor"):
        super(Speech,self).__init__(client_name)
        self.status = False

    def get_language_person_dict(self):
        dictionary = {}
        voices = self.list_synthesis_voices()
        for item in voices:
            if(item[1] not in dictionary):
                dictionary[item[1]] = [item[0]]
            else:
                dictionary[item[1]].append(item[0])
        return dictionary

    def get_language_index(self, language):
        if(language in self.get_language_person_dict().keys()):
            index = list(self.get_language_person_dict().keys()).index(language)
            return index

        # eSpeak-ng lists languages differently in its new and old versions. 
        # In the new version, English UK and US are listed separately 
        # as en-US and en-GB, removing the 'en'.
        elif (self.get_output_module() == "espeak-ng" and language in espeak_ng_alternative_dict.keys()):
            index = list(self.get_language_person_dict().keys()).index(espeak_ng_alternative_dict[language])
            return index
        else:
            return -1

    def say(self,text):
        self.status = True
        self.speak(text,self.end,speechd.CallbackType.END)

    def wait(self):
        while (self.status):
            pass

    def end(self,*data):
        self.status = False

    def list_synthesizers(self):
        return self.list_output_modules()

    def set_synthesizer(self, synthesizer):
        self.set_output_module(synthesizer)

    def get_speech_rate(self):
        # Converting to a rate range of 0 to 100
        speech_rate = int(self.get_rate())
        return int((speech_rate+100)/2)

    def set_speech_rate(self, speech_rate):
        if(speech_rate >= 0 and speech_rate <= 100):
            # Converting to the speech-dispatcher rate range of -100 to 100.
            rate = int((speech_rate*2)-100)
            self.set_rate(rate)
