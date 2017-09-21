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

- Allow users to send feedback
- Set up a revenue model and support it in the app
- Deep testing and bug fixing
- Release

#### Features and technical improvements

- Facebook picture and video integration (try this: https://github.com/bakkenbaeck/Viewer)
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

### App Store Optimization

- Hasznos cikkek vannak itt kigyűjtve az ASO-hoz: https://www.mindmeister.com/875122694/app-store-optimization-the-essential-aso-resources-list
- *The format of both descriptions is the same: “You do X and Y happens.” X is the input and Y is the output. This input-output pair matches our intuition about how software works. Simplifying the product as a straightforward input and desirable output creates the sense that it’s an ingenious idea.*
- *All the users follow the same process: check the icon, view the first two screenshots, and scan the first line of the app description.* Egy átlagos user 7 másodpercet szán erre. Ez viszont csak a régi app storeban volt igaz! Az újban már autoplay fognak futni a videók és a search result is sokkal tartalmasabb lesz.

### Marketing

- Az app store page a legfontosabb.
- A jó értékelés számít, mert a potencionális user meg fogja nézni őket letöltés előtt. Kérhetem az appon belül a usereket, hogy értékeljék azt.
- Mobile appokkal foglalkozó siteokon review.
- Social médiában megosztás általam vagy az ismerőseim által.
- Hírdetés bannereken (Google, Apple, stb).
- Hírdetés emailben.

### Design

- Ikon generáláshoz hasznos lehet: https://appiconizer.com

### Cikkek, amik még jól jöhetnek

- Design, marketing, pricing, release:
	- https://www.appsposure.com/app-marketing-strategies/
	- https://applaunchmap.com/blog/
	- https://fabric.io/blog/introducing-fastlane-precheck
	- https://developer.apple.com/app-store/product-page/
	- https://developer.apple.com/videos/play/wwdc2017/305/
	- https://medium.com/flawless-app-stories/flawlessapp-on-producthunt-7db3e561ce7a
	- https://www.sideprojectchecklist.com/marketing-checklist/
	- https://blog.halide.cam/one-weird-trick-to-lose-size-c0a4013de331
	- https://medium.com/@garyvee/make-money-dont-raise-money-24a92dde76c5
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
