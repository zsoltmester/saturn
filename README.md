# Project Saturn

## Mi a problémám?

Túl sok felületen kell végigmennem ahhoz, hogy az engem érdeklő híreket átnézzem, pl: FB, Insta, Index, HVG, Hacker News, reddit programming, YouTube.

## Megoldás

Egy olyan hírolvasó app, amivel saját magam állíthatok össze hírfolyamokat.

Például én ezeket hoznám létre magamnak első körben:
- **Developer's Heaven**: Hacker News + reddit programming
- **Chill**: some YouTube channels
- **Hearthstone**: some YouTube channels of HS players and the official channel + Facebook posts by the HS official
- **Essential**: Index + HVG
- **AKPH**: FB + YouTube of AKPH

## Saturn.iOS

Az előző fejezetben nagyvonalakban leírt alkalmazás iOS-en implementálva. Az alkalmazás a lehető legegyszerűbb legyen. A felület és a UX és megfelel az Apple ajánlásainak és a jelenlegi trendeknek.

### Támogatottság

A legalább 10-es főverzióval rendelkező iPhone-ok támogatottak. Utána mindig az aktuális és az előző főverzió támogatott. Egyelőre csak a portrait módban használható az app.

### Roadmap

#### Features

- Refactor the feed list screen: remove the color pastel view (also from model and feed editor) and group the sources by providers, where each provider is a new line
- Cache (news, pictures, videos, other media...)
- Support refresh on the feed screen (swipe to refresh + button)
- Support loading more news on the news screen
- Sending app feedbacks
- Share news
- Save news
- Support iPad devices and iPhones' landscape mode
- User onboarding
- Improve feed editor screen: search, preview and select the source
- Make texts selectable on the news screen

#### News providers and sources

- Include replies, quotes and retweets on Twitter
- Integrate Instagram
- Support more on Reddit, other then a subreddit's hot

#### Technical improvements

- Analytics (log the current print statements too)
- Using the new safe layout guides
- Convert project to Swift 4
- Integrate LicensePlist

#### Bugs

- Ha túl hosszú a név, mikor hozzáadunk egy feedet, crashel

### Cikkek, amik még jól jöhetnek

- Safe layout guide-hoz:
	- https://useyourloaf.com/blog/safe-area-layout-guide
- iPad supporthoz:
	- https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf
- LicensePlist:
	- https://github.com/mono0926/LicensePlist
- Onboardinghoz:
	- https://www.appcues.com/blog/user-onboarding-messaging-apps/
- Analitikához:
	- https://golocalapps.com/find-your-apps-super-users-and-hack-your-growth/
- Gamificationhöz:
	- https://uxplanet.org/gamification-in-2017-top-5-key-principles-cef948254dad
- Design, marketing, pricing, release:
	- http://stephencoyle.net/appstore
	- https://www.dancounsell.com/articles/subscription-based-pricing-is-not-the-answer
	- "It’s much easier to upsell to an existing customer than it is to find an entirely new paying customer."
	- https://medium.com/joytunes/wwdc-2017-amazing-new-features-for-subscriptions-676662a7d993
	- https://appiconizer.com/
	- https://medium.dave-bailey.com/the-magic-formula-to-describe-a-product-in-one-sentence-175ce38619c7
	- http://incipia.co/post/app-marketing/the-essential-app-store-optimization-resources-list/
	- https://www.apppartner.com/16-experts-strategies-downloads/
	- https://www.appsposure.com/app-marketing-strategies/
	- https://applaunchmap.com/blog/
	- https://fabric.io/blog/introducing-fastlane-precheck
	- https://developer.apple.com/app-store/product-page/
	- https://developer.apple.com/videos/play/wwdc2017/305/
	- https://stories.appbot.co/how-often-should-you-update-your-app-9405b85a967c
	- https://medium.com/mobile-growth/how-to-get-more-app-downloads-by-rethinking-your-mobile-marketing-strategy-150ed4cc4e28
	- https://medium.com/flawless-app-stories/flawlessapp-on-producthunt-7db3e561ce7a
	- https://www.sideprojectchecklist.com/marketing-checklist/
	- https://blog.halide.cam/one-weird-trick-to-lose-size-c0a4013de331
	- https://uxplanet.org/lean-and-mean-power-of-minimalism-in-ui-design-5ca37eb32ac8

#### Facebook

- https://developers.facebook.com/apps/325772207834932/dashboard/
- https://developers.facebook.com/tools/explorer
- https://developers.facebook.com/docs/swift/graph
- https://developers.facebook.com/docs/graph-api/reference/page/#Overview
- https://developers.facebook.com/docs/graph-api/reference/v2.9/post
- https://developers.facebook.com/docs/graph-api/reference/v2.9/attachment

#### YouTube

- https://developers.google.com/youtube/v3/guides/ios_youtube_helper
- https://developers.google.com/youtube/player_parameters
