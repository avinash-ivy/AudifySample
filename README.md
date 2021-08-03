# AudifySample
This project has sample code to fetch media list from iTunes Library and save it to Core Data.

# Screens
This project has 2 screens - 
1. Main screen
   a. Helps to fetch first media item in iTunes Library
   b. Edit the meta data of the audio fetched
   c. Fetch the audio from Core Data saved in same or any previous sessions.
   
2. Edit screen - This screen will have provision to edit the data and save it to Core Data.

# Design
MVC with Flow Coordinator (Not enough scope to go with MVVM)
Core Data used a Presistent Storage. (Core Data internally uses DB, but we need not bother about the exact implementation)

# Steps to follow
1. When you are accessing app for first time, click on import audio
2. Once you see the meta data populated, wait for couple of seconds to save the audio to storage.
3. Once save is done, you can edit the details of click on fetch song to fetch from storage and play.
4. If it is not a first lauch, then you can simply click on fetch song and listen to the song. Meta data also should get populated.

# App in action
You can check a quick demo video clicking on this screen grab

[![Watch the video](https://user-images.githubusercontent.com/17071826/127970819-09ebcaef-e30c-4ef9-84a0-edfc637faf1d.png)](https://youtu.be/1l--a-QgKFE)


