# Project Saturn

## Mi a problémám?

Túl sok felületen kell végigmennem ahhoz, hogy az engem érdeklő híreket és hírfolyamokat átnézzem, pl: FB, Insta, Index, HVG, Hacker News, reddit programming.

## Megoldás

Egy olyan applikáció, ami képes egy felületen kezelni az engem érdeklő hírfolyamokat (pl Twitter, Index, Hacker News). Tudjak saját hírfolyamokat gyártani, pl:
- *Developer's Heaven*: Hacker News + reddit programming;
- *iOS Dev*: Apple.com, any articles about Apple from Index or HVG, Twitter feed of iOS developers, Youtube videos of Apple related channels;
- *Android Dev*: ...
- *Geeks*: ...
- *Syrian War*: Articles from all the top news sites (The New York Times, Guardians, etc) about the Syrian War;
- *Music*: YouTube, SoundCloud, Insta and FB contents of my favourite musicians;
- *Chill*: 9gag, some YouTube channels;
- stb.

## Saturn.iOS

Az előző fejezetben nagyvonalakban leírt alkalmazás iOS-en implementálva.

Úgy gondolom, hogy a fönt leírt probléma sok embert érint, ezért egy bárki által könnyen használható, testreszabható appot készítek. A felület és a UX megfelel az Apple ajánlásainak és a jelenlegi trendeknek. A legalább 10-es OS főverzióval rendelkező iPhoneok a támogatottak.

### Ami még biztos hátravan R1-ig

- A hírfolyamválasztó képernyő:
	- fejlécének bal oldalán található egy edit button, amivel a lista edit módba kapcsol, ahol a lista elemeit mozgatni, törölni és módosítani is lehet. A módosítás a hírfolyamódosító képernyőt indítja el, modal segue-el. Ha mentéssel érkeztünk vissza, akkor frissüljön a lista.
	- fejlécének jobb oldalán található egy add button, amire kattintva egy modal segue visz el a hírfolyamlétrehozó képernyőre. Ha mentéssel érkeztünk vissza, akkor frissüljön a lista.
- A hírfolyamlétrehozó képernyő:
	- fejlécének jobb oldalán egy done button található, ami elmenti a megadott értékek alapján a hírfolyamot, úgy, hogy a hírfolyamválasztó lista első helyére kerüljün. Ezután eldobja a képernyőt. A gomb csak akkor aktív, ha valid a név és legalább 1 hírforrás hozzá van adva.
- A hírfolyam képernyő:
	- csak navigation controlleren keresztül érhető el, ezért mindig van a tetején egy fejléc.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- címe a hírfolyam címe.
	- egy cellája egy hírt reprezentál. A cella tartalmazza a hír címét, leírását és egy képet. A kép a bal oldalon jelenik meg, a két szöveg pedig a kép mellett a jobb oldalon, középre igazítva, fölül a címmel. Legfeljebb 2 sor lehet a cím és 2 sor a leírás. A lista egy elemére kattintva egy show segue visz el a hír képernyőre.
	- listája a szokásos módon frissíthető. **TODO: Mennyi hírt töltsünk be / le és hogy frissítsük?**
- A hír képernyő:
	- csak navigation controlleren keresztül érhető el, ezért mindig van a tetején egy fejléc.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- címe a hírfolyam címe.
	- tartalma egy webview, amiben a hír betöltődik.

### Ötletek

- Feedback from users
- Share news
- "Read later" storage
- Translator
- Alerts from Google for keywords
- Twitter topics
- Bouncy layout
- Pastel view before the disclosure indicator, on the color row, in the add feed screen
