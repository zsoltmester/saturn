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

Úgy gondolom, hogy a fönt leírt probléma sok embert érint, ezért egy bárki által könnyen használható, testreszabható appot készítek. A felület és a UX megfelel az Apple ajánlásainak és a jelenlegi trendeknek. A legalább 10-es OS főverzióval rendelkező iPhoneok és iPadek a támogatottak.

### Specifikáció

#### Fogalmak

- **News** (hír): Egy cikk, egy videó, egy podcast, egy insta vagy fb post, stb.
- **News Source** (hírforrás): Amik a híreket gyártják, például Index, YouTube, Twitter, stb.
- **News Feed** (hírfolyam): Hírek egy halmaza.

#### Funkcionális Specifikáció

1. Telepíthető legyen az app storeból és azon keresztül frissüljön.
- A hírfolyamválasztó képernyő:
	- a kezdőképernyő.
	- egy navigation controllerbe van ágyazva.
	- címe arra utal, hogy ez a lista a user hírfolyamait tartalmazza. Például *Your Feeds*.
	- fejlécének bal oldalán található egy edit button, amivel a lista edit módba kapcsol, ahol a lista elemeit mozgatni, törölni és módosítani is lehet. A módosítás a hírfolyamódosító képernyőt indítja el, modal segue-el. Ha mentéssel érkeztünk vissza, akkor frissüljön a lista.
	- fejlécének jobb oldalán található egy add button, amire kattintva egy modal segue visz el a hírfolyamlétrehozó képernyőre. Ha mentéssel érkeztünk vissza, akkor frissüljön a lista.
	- egy plain table viewt tartalmaz.
	- egy cellája egy hírfolyamot reprezentál. A cella tartalmazza a hírfolyam nevét, egy képként a színárnyalatát és felsorolja a forrásokat. A kép a bal oldalon jelenik meg, a hírfolyam neve és a források pedig a kép mellett a jobb oldalon, középre igazítva, fölül a hírfolyam nevével. A hírfolyam neve nem, de a forráslista 2 sorba lehet törve. A lista egy elemére kattintva egy show segue visz el a hírfolyam képernyőre.
- A hírfolyamlétrehozó képernyő:
	- egy navigation controllerbe van ágyazva.
	- címe arra utal, hogy egy új hírfolyamot hoz létre a user. Például: *Add Feed*.
	- fejlécének bal oldalán egy cancel button található, ami eldobja a képernyőt.
	- fejlécének jobb oldalán egy done button található, ami elmenti a megadott értékek alapján a hírfolyamot, úgy, hogy a hírfolyamválasztó lista első helyére kerüljün. Ezután eldobja a képernyőt. A gomb csak akkor aktív, ha valid a név és legalább 1 hírforrás hozzá van adva.
	- egy grouped table viewt tartalmaz.
	- szekcióinak nincs neve.
	- első szekciójának egy eleme van. Ebbe a nevet lehet beírni, hasonlóan, ahogy a calendar alkalmazásban egy új event nevét lehet beírni.
	- második szekciójának egy eleme van. Ennek bal oldalán egy színre utaló szöveg szerepel, például *Color*. Jobb oldalán és egy disclosure indicator. Az elemre kattintva a színválasztó képernyőre jutunk.
	- harmadik szekciója egy kicsit hasonlít a contact alkalmazás hozzáadás funkciójában lévő URL szekcióra. A létrehozóként funkcionáló cella
		- tartalmaz egy gombot, egy magyarázó szöveget és egy beviteli mezőt. Az előző sorrendben, föntről lefele, balra rendezve.
		- a gomb jobb oldalán egy disclosure indicator van.
		- a gomb a forrásválasztó képernyőre visz el. Ha módosítással tért vissza, akkor frissítjük a gombot és a szöveget, és töröljük a beviteli mező tartalmát.
		- ha a user rányomott a hozzáadás gombra, akkor a képernyőn minden action kikapcsoltá válik. A háttérben validáljuk, hogy helyes-e a forrás. Egy activity indicator + szöveg is megjelenik a harmadik szekció footerében. Ha a validáció sikeres volt, akkor hozzáadjuk a forrást, különben pedig egy alertet dobunk fel, hogy nem találtuk meg a forrást. Az alertet csak eldobni lehet.
		- a forrás cellában csak egy szöveg van, amin a forrás típusáról és a serviceről.
- A forrásválasztó képernyő:
	- egy navigation controllerbe van ágyazva.
	- címe arra utal, hogy egy hírforrás típusát választhatja ki a user. Például: *Type*.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- egy table view, ami két sectiont tartalmaz.
	- első sectionjében az RSS és az Atom található.
	- második sectionjében pedig azok a szolgáltatások, amikhez van integrációnk. Ilyen például a Facebook, Instagram, Twitter, Reddit.
	- aktuálisan kiválasztott elemének jobb szélén egy pipa van.
- A hírfolyammódosító képernyő:
	- csak az alábbiakban különbözik a hírfolyamlétrehozó képernyőtől:
		- címe arra utal, hogy egy hírfolyamot módosít a user. Például: *Edit Feed*.
		- minden szekciója elő van töltve.
- Színválasztó képernyő:
	- csak navigation controlleren keresztül érhető el, ezért mindig van a tetején egy fejléc.
	- címe arra utal, hogy egy színt tud kiválasztani a user. Például: *Color*.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- egy collection viewban tartalmazza a színárnyalatokat, képként felsorolva. Ezek közül pontosan egy lehet aktív, azaz kiválasztott. Válogatni tappolással lehet. A kiválasztott kép szélének a global tintnek megfelelő színű szegélye van.
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

- Share news
- "Read later" storage
- Translator
- Alerts from Google for keywords
- Share feeds
