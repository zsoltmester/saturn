# Project Saturn

## Mi a problémám?

Túl sok felületen kell végigmennem ahhoz, hogy az engem érdeklő híreket átnézzem, pl: FB, Insta, Index, HVG, Hacker News, reddit programming, YouTube.

## Megoldás

Egy olyan hírolvasó app, amivel saját magam állíthatok össze hírfolyamokat.

Például én ezeket hoznám létre magamnak első körben:
- *Developer's Heaven*: Hacker News + reddit programming
- *Chill*: some YouTube channels
- *Hearthstone*: some YouTube channels of HS players and the official channel + Facebook posts by the HS official
- *Essential*: Index + HVG
- *AKPH*: FB + YouTube of AKPH

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

### Possible new features

- Cache (news, pictures, videos, other media...)
- iOS 11 support
- Feedback from users
- Share news
- Save news
- Support iPad devices and iPhones' landscape mode
- Analytics
- Pastel view before the disclosure indicator, on the color row, in the add feed screen
- Integrate LicensePlist
- 3D touch (can I use for something?)
- Onboarding

### Cikkek, amik még jól jöhetnek

- iPad supporthoz: https://convertkit.s3.amazonaws.com/assets/documents/747/538975/iOS_Size_Classes_Quick_Guide_v1.3.pdf
- LicensePlist: https://github.com/mono0926/LicensePlist
- Pricing: http://stephencoyle.net/appstore, https://www.dancounsell.com/articles/subscription-based-pricing-is-not-the-answer, "It’s much easier to upsell to an existing customer than it is to find an entirely new paying customer."
- Design: https://appiconizer.com/, https://medium.dave-bailey.com/the-magic-formula-to-describe-a-product-in-one-sentence-175ce38619c7, http://incipia.co/post/app-marketing/the-essential-app-store-optimization-resources-list/
- Onboardinghoz: https://www.appcues.com/blog/user-onboarding-messaging-apps/
- iOS 11 supporthoz: https://medium.com/@hacknicity/working-with-multiple-versions-of-xcode-e331c01aa6bc, https://medium.com/the-traveled-ios-developers-guide/ios-11-notable-uikit-additions-92e5eb421c3b
