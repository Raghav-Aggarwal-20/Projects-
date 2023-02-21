from pytube import YouTube
from pydub import AudioSegment
import urllib.request
import re
import os
import sys

def load_files(x,n):
    html = urllib.request.urlopen('https://www.youtube.com/results?search_query=' + str(x))
    video_ids = re.findall(r"watch\?v=(\S{11})", html.read().decode())

    for i in range(n):
        yt = YouTube("https://www.youtube.com/watch?v=" + video_ids[i]) 
        print("Song "+str(i+1)+" downloading ......")
        mp4files = yt.streams.filter(only_audio=True).first().download(filename='song-'+str(i)+'.mp3')

    print("!!Songs downloaded successfully!!")
    print("Starting to create mashup.....")

def merging_sound(n,y):
    if os.path.isfile("song-0.mp3"):
        try:
            f_sound = AudioSegment.from_file("song-0.mp3")[0:y*1000]
        except:
            f_sound = AudioSegment.from_file("song-0.mp3",format="mp4")[0:y*1000]
    for i in range(1,n):
        audio_file = str(os.getcwd()) + "/song-"+str(i)+".mp3"
        try:
            f = AudioSegment.from_file(audio_file)
            f_sound = f_sound.append(f[0:y*1000],crossfade=1000)
        except:
            f = AudioSegment.from_file(audio_file,format="mp4")
            f_sound = f_sound.append(f[0:y*1000],crossfade=1000)
        
    return f_sound

def main():
    if len(sys.argv) == 5:
        x = sys.argv[1]
        x = x.replace(' ','') + "songs"
        try:
            n = int(sys.argv[2])
            y = int(sys.argv[3])
        except:
            sys.exit("Wrong Parameters entered")
        output_name = sys.argv[4]
    else:
        sys.exit('Wrong number of arguments provided! (PLEASE provide 4)')

    load_files(x,n)
    fin_sound = merging_sound(n,y)

    fin_sound.export(output_name, format="mp3")
    print("Created Mashup successfully!!")

if __name__ == '__main__':
    main()



