## Twitter Demo

## Twitter Week 4

Time spent: 17 hours

#### Required

- [x] Hamburger Menu - Dragging anywhere in the view should reveal the menu
- [x] Hamburger Menu - The menu should include links to your profile, the home timeline, and the mentions view
- [x] Hamburger Menu - The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI
- [x] Profile - Contains the user header view
- [x] Profile - Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Tapping on a user image should bring up that user's profile page

#### Optional

- [x] Pulling down the profile page should blur and resize the header image.
- [x] Scroll up the profile page will hide user's detal information and show cutomize navigation bar with user's name and tweet count
- [x] Customize animation/effect for Profile page scroll view, like the real Twitter application.

### Walkthrough

![Video Walkthrough](kehuang_twitter_2.gif)

## Twitter Week 3

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: 19 hours

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] When reply a tweet, in compose view, user can pull down to view the text of tweet they intend to reply

### Walkthrough

Walkthrough of all user stories:
 
![Video Walkthrough](kehuang_twitter.gif)
 
### 3rd party library

GIF created with [LiceCap](http://www.cockos.com/licecap/).

[AFNetworking](https://github.com/AFNetworking/AFNetworking)
[BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
[SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)
[DateTools](https://github.com/MatthewYork/DateTools)
[BlurImageProcessor](https://github.com/danielalves/BlurImageProcessor)