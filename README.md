# Final Project - *Thinh*

Time spent: **X** hours spent in total

## User Stories

+ Thinh is a chat application with feature "tha thinh". You have a button to send "tha thinh" (like) someone (maybe include a photo/video).
   + If the target users are your friend, they only know that (and get the photo/video) when they also "tha thinh" (like) you.
   + If the target users are not your friend, they will get a notification. And they get your photo/video when they accept your request (take the "thinh")


The following **required** functionality is completed:

- [ ] Login, signup page
   - [ ] Login with facebook.
   - [ ] Sign up with email, google (optional).
   - [ ] Import contact from contact/facebook.
   - [ ] After user signup, prompt to get user description
- [ ] Profile page
   - [ ] Contains the user header view
   - [ ] Contains avatar
   - [ ] Contains user info: email, name, day of birth, gender, phone number
   - [ ] User can edit their info (optional)
- [ ] Chat list page
   - [ ] List friend with avatar, status
   - [ ] "Tha thinh" again button (optional)
   - [ ] Online indicator (optional)
   - [ ] Tapping on a user image should bring up that user's profile page.
   - [ ] Tapping on user cell should bring up to chat page.
   - [ ] List waiting for response from whom user have liked ("tha thinh") (optional).
- [ ] Chat page
   - [ ] Contains the user info: avatar, name
   - [ ] Contains input text field to type messages
   - [ ] Contains sent and received messages with avatar (like iMessages)
   - [ ] User can send text
   - [ ] User is typing indicator
   - [ ] User can send photo, video (optional)
- [ ] Tha Thinh page
   - [ ] Contains list of new user and friend who've not yet received "thinh"
   - [ ] User cell: contain avatar, name, description, "tha thinh" (like) button
- [ ] Setting page
   - [ ] gender setting
   - [ ] notification setting (optional)
   - [ ] range of age to show in "Find friend page" (optional)
   - [ ] time out for "tha thinh" (optional).
- [ ] When user click "tha thinh" to:
   - [ ] new user (target user) (not in friend list):
      - [ ] send user id to target user
      - [ ] a notification is sent to target user (optional)
      - [ ] if target user "dop thinh", he/she can see the avatar and start to chat
   - [ ] friend (target user) (in friend list):
      - [ ] send user id to target user
      - [ ] there is no notification to target user
      - [ ] if target user also "tha thinh", he/she can start to chat


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
