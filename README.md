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

- Facebook integration
- Try the Viewer lib for FB images and videos (https://github.com/bakkenbaeck/Viewer)
- Allow users to send feedback
- Set up a revenue model and support it in the app
- Deep testing and bug fixing
- Release

#### Features and technical improvements

- Cache (news, pictures, videos, other media...)
- Support refresh on the feed screen (swipe to refresh + button)
- Support loading more news on the news screen
- Sending app feedbacks
- Share news
- Save news
- Adaptive layout: support iPad devices and iPhones' landscape mode (https://www.raywenderlich.com/162311/adaptive-layout-tutorial-ios-11-getting-started, https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf)
- Improve feed editor screen: search, preview and select the source
- Create a launch screen
- Support for misc info (likes, shares, retweets, comments...)
- Eliminate the links on Twitter texts
- Integrate Instagram
- Support more on Reddit, other then a subreddit's hot
- Loading animation on the web view
- Analytics (log the current print statements too)
- Using the new safe layout guides (https://useyourloaf.com/blog/safe-area-layout-guide)

#### Bugs

- Ha túl hosszú a név, mikor hozzáadunk egy feedet, crashel (valószínűleg a query-nél is hansonló a helyzet)
- Sokáig tölt a feed list képernyőn, ha egy feedre akarok navigálni
- Ha nincs idő egy hírhez, akkor a time label helytelenül jelenik meg
- Nem lehet tovább navigálni, ha egy hír cellában a textviewra kattintunk

### Revenue

- Az IAP egy járható út.
	1. Lehetne egy korlátozott tartalommal rendelkező ingyenes és egy teljes tartalommal rendelkező pro verzió is.
 	2. Lehetne egy reklámmal teli teljes tartalommal rendelkező ingyenes app, aminél a reklámmentességért kell fizetni.
	3. Az előbbi 2 keveréke.
- A reklámok nagyon kevés pénzt adnak az IAP-hez képest. A reklámokból viszont minden user után profitálhatok, az IAP-ből meg csak vásárlás után, amire kevés user hajlandó.
- "It’s much easier to upsell to an existing customer than it is to find an entirely new paying customer."

### Marketing

- Mobile appokkal foglalkozó siteokon review.
- Social médiában megosztás általam vagy az ismerőseim által.

### Cikkek, amik még jól jöhetnek

- Revenue:
	- Subscriptions: https://medium.com/joytunes/wwdc-2017-amazing-new-features-for-subscriptions-676662a7d993, https://www.theverge.com/2017/8/15/16147954/liftoff-report-apple-ios-android-app-subscriptions-conversion-rate-2017
- App store and design:
	- https://appiconizer.com
- Design, marketing, pricing, release:
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

#### Facebook

- https://developers.facebook.com/apps/325772207834932/dashboard/
- https://developers.facebook.com/tools/explorer
- https://developers.facebook.com/docs/swift/graph
- https://developers.facebook.com/docs/graph-api/reference/page/#Overview
- https://developers.facebook.com/docs/graph-api/reference/v2.9/post
- https://developers.facebook.com/docs/graph-api/reference/v2.9/attachment
