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

A legalább 11-es főverzióval rendelkező iPhone-ok támogatottak. Utána mindig az aktuális és az előző főverzió támogatott. Egyelőre csak a portrait módban használható az app.

### Roadmap

#### TODO for MVP

- Handle click on news cells, where there are links
- Show the source after the time on a news cell
- Try the Viewer lib for images and videos
- Sort news based on time
- Atom integration
- Reddit integration
- YouTube integration
- Facebook integration

#### Features

- The sources label's providers name text should be more strong
- Cache (news, pictures, videos, other media...)
- Support refresh on the feed screen (swipe to refresh + button)
- Support loading more news on the news screen
- Sending app feedbacks
- Share news
- Save news
- Support iPad devices and iPhones' landscape mode
- Improve feed editor screen: search, preview and select the source
- Create a launch screen
- Support for misc info (likes, shares, retweets, comments...)
- Eliminate the links on Twitter texts
- Integrate Instagram
- Support more on Reddit, other then a subreddit's hot

#### Technical improvements

- The non-optional core data properties should be non-optional
- Analytics (log the current print statements too)
- Using the new safe layout guides

#### Bugs

- Ha túl hosszú a név, mikor hozzáadunk egy feedet, crashel (valószínűleg a query-nél is hansonló a helyzet)

### Cikkek, amik még jól jöhetnek

- Viewer lib for images and videos:
	- https://github.com/bakkenbaeck/Viewer
- Safe layout guidehoz:
	- https://useyourloaf.com/blog/safe-area-layout-guide
- iPad supporthoz:
	- https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf
- Analitikához:
	- https://golocalapps.com/find-your-apps-super-users-and-hack-your-growth/
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
	- https://developer.apple.com/news/?id=07182017a
	- https://medium.com/@garyvee/make-money-dont-raise-money-24a92dde76c5
	- https://appradar.com/blog/how-apple-crushes-your-usual-app-store-optimization-strategy
	- https://blog.branch.io/and-the-winners-of-the-mobile-growth-stories-challenge-are
	- http://martiancraft.com/blog/2017/05/demystifying-ios-provisioning-part1/
	- http://martiancraft.com/blog/2017/07/demystifying-provisioning-part2/
	- https://www.andrewcbancroft.com/2017/08/01/local-receipt-validation-swift-start-finish/
	- https://www.apptamin.com/blog/ios-11-app-previews/
	- https://www.theverge.com/2017/8/15/16147954/liftoff-report-apple-ios-android-app-subscriptions-conversion-rate-2017

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
