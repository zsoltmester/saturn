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

### Ami még biztos hátravan az MVP-ig

- A hírfolyam képernyő:
	- Nem kell az, hogy cacheljünk!
	- A table view nem frissíthető (se swipe, se refresh button)!
	- Hogy mennyi hírt töltsünk le egy feedhez, az nem konfigurálható, csak az, hogy mennyi új hírt töltsön le egy Fetchable egy fetchnél. (default = 20)
	- Ha leértünk a screen aljára, akkor töltjük a következő adagot
	- Megjeleníteni a híreket

- Integrálni akarom:
	- RSS feed
	- Twitter
	- Facebook
	- YouTube
	- Reddit

### Possible new features and improvements

- Cache (news, pictures, videos, other media...)
- Convert project to Swift 4
- Feedback from users
- Share news
- Save news
- Support iPad devices and iPhones' landscape mode
- Analytics (log the current print statements too)
- Pastel view before the disclosure indicator, on the color row, in the add feed screen
- Integrate LicensePlist
- 3D touch (can I use for something?)
- Onboarding
- Instagram integráció
- Copy API support
- Validate news source before add
- Move the strings to the Localizable.strings
- Create a global constants file and move the constants there
- Refactor FetchError to a concrete error enum

### Cikkek, amik még jól jöhetnek

- Kép letöltéshez:
	- https://medium.com/@matthew_healy/loading-images-in-ios-without-dependencies-aff1555dbf1e
- iPad supporthoz:
	- https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf
- LicensePlist:
	- https://github.com/mono0926/LicensePlist
- Onboardinghoz:
	- https://www.appcues.com/blog/user-onboarding-messaging-apps/
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

#### Facebook

- https://developers.facebook.com/apps/325772207834932/dashboard/
- https://developers.facebook.com/tools/explorer
- https://developers.facebook.com/docs/swift/graph
- https://developers.facebook.com/docs/graph-api/reference/page/#Overview
- https://developers.facebook.com/docs/graph-api/reference/v2.9/post
- https://developers.facebook.com/docs/graph-api/reference/v2.9/attachment

#### Twitter

- https://dev.twitter.com/twitterkit/ios/overview

#### YouTube

- https://developers.google.com/youtube/v3/guides/ios_youtube_helper
- https://developers.google.com/youtube/player_parameters
