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

- Update the screenshots in the store
- Check for the dependent beta framework
- Release

#### Features and technical improvements

- Add an onboarding widget to the empty dashboard
- Facebook ismerősöket is hozzá lehessen adni (vagy jelezzük, hogy az API ilyet nem enged)
- UX redesign (onboarding, user stories...)
- Refactor the feed list screen (groupped by feed; 1 source 1 line, with image)
- Facebook picture and video integration (try this: https://github.com/bakkenbaeck/Viewer)
- Cache (news, pictures, videos, other media...)
- Support refresh on the feed screen (swipe to refresh + button)
- Support loading more news on the news screen
- Sending app feedbacks
- Save news
- Adaptive layout: support iPad devices and iPhones' landscape mode (https://www.raywenderlich.com/162311/adaptive-layout-tutorial-ios-11-getting-started, https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf)
- Improve feed editor screen: search, preview and select the source
- Create a launch screen
- Support for misc info (likes, shares, retweets, comments...)
- Eliminate the links on Twitter texts
- Integrate Instagram
- Support more on Reddit, other then a subreddit's hot
- Analytics (log the current print statements too)
- Using the new safe layout guides (https://useyourloaf.com/blog/safe-area-layout-guide)
- iPhone X support

#### Bugs

- Nem lehet tovább navigálni, ha egy hír cellában a textviewra kattintunk
- Nem rendereli jól a hír listán a kép nélküli cellákat

### Revenue

- Apple-ös összefoglaló: https://developer.apple.com/app-store/business-models/
- Az IAP egy járható út.
	1. Lehetne egy korlátozott tartalommal rendelkező ingyenes és egy teljes tartalommal rendelkező pro verzió is.
 	2. Lehetne egy reklámmal teli teljes tartalommal rendelkező ingyenes app, aminél a reklámmentességért kell fizetni.
	3. Az előbbi 2 keveréke.
- A reklámok nagyon kevés pénzt adnak az IAP-hez képest. A reklámokból viszont minden user után profitálhatok, az IAP-ből meg csak vásárlás után, amire kevés user hajlandó.
- "It’s much easier to upsell to an existing customer than it is to find an entirely new paying customer."

### App Store Optimization

- Hasznos cikkek vannak itt kigyűjtve az ASO-hoz: https://www.mindmeister.com/875122694/app-store-optimization-the-essential-aso-resources-list
- Apple magyarázatok: https://developer.apple.com/app-store/product-page/
- *The format of both descriptions is the same: “You do X and Y happens.” X is the input and Y is the output. This input-output pair matches our intuition about how software works. Simplifying the product as a straightforward input and desirable output creates the sense that it’s an ingenious idea.*
- *All the users follow the same process: check the icon, view the first two screenshots, and scan the first line of the app description.* Egy átlagos user 7 másodpercet szán erre. Ez viszont csak a régi app storeban volt igaz! Az újban már autoplay fognak futni a videók és a search result is sokkal tartalmasabb lesz.

### Marketing

- Az app store page a legfontosabb.
- A jó értékelés számít, mert a potencionális user meg fogja nézni őket letöltés előtt. Kérhetem az appon belül a usereket, hogy értékeljék azt. Az instagram példája: https://medium.com/huggingface/instagram-doubled-its-ios-reviews-in-a-week-thanks-to-this-new-in-app-review-popup-52333d4f4ce6.
- Mobile appokkal foglalkozó siteokon review.
- Social médiában megosztás általam vagy az ismerőseim által.
- Hírdetés bannereken (Google, Apple, stb).
- Hírdetés emailben.

### Design

- Ikont itt keressek: https://www.flaticon.com
- Ikon generáláshoz: https://makeappicon.com/
- Ami jó lehet: https://www.flaticon.com/free-icon/rss_190585
- Az ikon készítőjét meg kell említeni: Icon made by Roundicons from www.flaticon.com
