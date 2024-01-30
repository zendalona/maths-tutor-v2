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

import sys
import configparser

class Preferences():

    def __init__(self):        
        self.set_default_preferences();

    """The values of the variables 'language,' 'speech_synthesizer,' and 'speech_language'
    have been set to -1 to initiate a fresh start. This enables the automatic 
    configuration of the speech synthesizer and speech language."""
    def set_default_preferences(self):
        self.operator = 0
        self.level = 0
        self.language = -1
        self.remember_language = 0
        self.speech_synthesizer = -1
        self.speech_language = -1
        self.speech_person = 0
        self.speech_rate = 50

    def load_preferences_from_file(self, filename):
        try:
            cp = configparser.ConfigParser()
            cp.read(filename)

            self.operator = int(cp.get('general',"operator"))
            self.level = int(cp.get('general',"level"))
            self.language = int(cp.get('general',"language"))
            self.remember_language = int(cp.get('general',"remember_language"))

            self.speech_synthesizer = int(cp.get('speech',"synthesizer"))
            self.speech_language = int(cp.get('speech',"language"))
            self.speech_person = int(cp.get('speech',"person"))
            self.speech_rate = int(cp.get('speech',"rate"))

            print(
                f"\n\n### Preferences loaded from {filename} ###\n"
                f"operator: {self.operator}\n"
                f"level: {self.level}\n"
                f"language: {self.language}\n"
                f"remember_language: {self.remember_language}\n"
                f"speech_synthesizer: {self.speech_synthesizer}\n"
                f"speech_language: {self.speech_language}\n"
                f"speech_person: {self.speech_person}\n"
                f"speech_rate: {self.speech_rate}\n\n"
            )

        except:
            print("Configuration reading error : ", sys.exc_info()[0])
            self.set_default_preferences()

    def save_preferences_to_file(self, filename):
        
        cp = configparser.ConfigParser()

        cp.add_section('general')
        cp.add_section('speech')

        cp.set('general',"language", str(int(self.language)))
        cp.set('general',"operator", str(int(self.operator)))
        cp.set('general',"level", str(int(self.level)))
        cp.set('general',"remember_language", str(int(self.remember_language)))

        cp.set('speech',"synthesizer", str(int(self.speech_synthesizer)))
        cp.set('speech',"language",str(int(self.speech_language)))
        cp.set('speech',"person",str(int(self.speech_person)))
        cp.set('speech',"rate",str(int(self.speech_rate)))


        with open(filename , 'w') as configfile:
            cp.write(configfile)

        print(
            f"\n\n### Preferences saved to {filename} ###\n"
            f"operator: {self.operator}\n"
            f"level: {self.level}\n"
            f"language: {self.language}\n"
            f"remember_language: {self.remember_language}\n"
            f"speech_synthesizer: {self.speech_synthesizer}\n"
            f"speech_language: {self.speech_language}\n"
            f"speech_person: {self.speech_person}\n"
            f"speech_rate: {self.speech_rate}\n\n"
        )
