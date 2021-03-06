# Final Project - *Thinh*

Time spent: **X** hours spent in total

## Survey Results:
https://docs.google.com/forms/d/1NV0Az2d02ZF9v5xA7GPLP9MKz0k1BroJig1uO6tT4jA/viewanalytics

## User Stories

+ Thinh is a chat application with feature "tha thinh". You have a button to send "tha thinh" (like) someone (maybe include a photo/video).
   + If the target users are your friend, they only know that (and get the photo/video) when they also "tha thinh" (like) you.
   + If the target users are not your friend, they will get a notification. And they get your photo/video when they accept your request (take the "thinh")


The following **required** functionality is completed:

- [ ] Login, signup page
   - [x] Login with facebook.
   - [ ] Sign up with email, google (optional).
   - [ ] Import contact from contact/facebook (optional).
   - [ ] After user signup, prompt to get user description
- [ ] Profile page
   - [x] Contains the user header view
   - [x] Contains avatar
   - [x] Contains user info: email, name, day of birth, gender, phone number
   - [ ] User can edit their info (optional)
- [ ] Chat list page
   - [x] List friend with avatar, status
   - [x] "Tha thinh" again button (optional)
   - [x] Online indicator (optional)
   - [x] Tapping on a user image should bring up that user's profile page.
   - [x] Tapping on user cell should bring up to chat page.
   - [x] List waiting for response from whom user have liked ("tha thinh") (optional).
- [ ] Chat page
   - [x] Contains the user info: avatar, name
   - [x] Contains input text field to type messages
   - [x] Contains sent and received messages with avatar (like iMessages)
   - [x] User can send text
   - [x] User is typing indicator
   - [x] User can send photo, video (optional)
- [ ] Tha Thinh page
   - [x] Contains list of new user and friend who've not yet received "thinh"
   - [x] User cell: contain avatar, name, description, "tha thinh" (like) button
- [ ] Setting page
   - [ ] gender setting
   - [ ] notification setting (optional)
   - [ ] range of age to show in "Find friend page" (optional)
   - [ ] time out for "tha thinh" (optional).
- [ ] When user click "tha thinh" to:
   - [ ] new user (target user) (not in friend list):
      - [x] send user id to target user
      - [x] a notification is sent to target user (optional)
      - [x] if target user "dop thinh", he/she can see the avatar and start to chat
   - [ ] friend (target user) (in friend list):
      - [x] send user id to target user
      - [x] there is no notification to target user
      - [x] if target user also "tha thinh", he/she can start to chat


The following **optional** features are implemented:

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
