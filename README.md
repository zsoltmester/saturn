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

Úgy gondolom, hogy a fönt leírt probléma sok embert érint, ezért egy bárki által könnyen használható, testreszabható appot készítek. A felület és a UX megfelel az Apple ajánlásainak és a jelenlegi trendeknek. A legfrissebb OS főverzióval rendelkező iPhoneok és iPadek támogatottak.

### Specifikáció

#### Fogalmak

- **News** (hír): Egy cikk, egy videó, egy podcast, egy insta vagy fb post, stb.
- **News Source** (hírforrás): Amik a híreket gyártják, például Index, YouTube, Twitter, stb.
- **News Feed** (hírfolyam): Hírek egy halmaza.

#### Funkcionális Specifikáció

1. Telepíthető legyen az app storeból és azon keresztül frissüljön.
2. A hírfolyamválasztó lista:
	- a kezdőképernyő.
	- egy navigation controllerbe van beágyazva.
	- címe arra utal, hogy ez a lista a user hírfolyamait tartalmazza. Példa cím: *Your Feeds*.
	- egy cellája egy hírfolyamot reprezentál. A cella tartalmazza a hírfolyam nevét és egy képet. A kép a bal oldalon jelenik meg, a cím pedig a kép mellett a jobb oldalon, középre igazítva. A cím nem lehet több sorba törve és megfelelő stílussal van kiemelve. A lista egy elemére kattintva egy show segue visz el a hírfolyam képernyőre.
	- fejlécének bal oldalán található egy edit button, amivel a lista a szokásos edit módba kapcsol, ahol a lista elemeit mozgatni, törölni és módosítani is lehet. A módosítás az előtöltött hírfolyamlétrehozó flowt indítja el. Ha mentéssel érkeztünk vissza, akkor frissítjük a listát.
	- fejlécének jobb oldalán található egy add button, amire kattintva egy modal segue visz el a hírfolyamlétrehozó képernyőre.
3. A hírfolyamlétrehozó flow:
	- 2 screenből áll, amik egy navigation controllerbe vannak beágyazva.
	- mindkét képernyő fejlécének bal oldalán egy cancel button található, ami eldobja a képernyőt.
	- mindkét képernyő címe arra utal, hogy egy új hírfolyamot hoz létre a user. Például: *Add Feed*. A második screenen a név leíró text field meg fogja változtatni ennek az értékét.
	- első képernyője egy hírforrás választó táblázat. A táblázatban annyi szekció van, amennyi különböző hírforráscsoport, minden szekció megfeleltetve egynek. Egy hírforráscsoporthoz tartozik egy főhírforrás (ami a hírforrás minden alhírforrását jelenti) és alhírforrások. A főhírforrás ki van emelve és mindig az első a szekcióban. Főhírforrás például: *HVG*. Névkonvenció alhírforrásokhoz: *főhírforrás - alhírforrás*, például: *Index - Sport, TechCrunch - Apple, TechCrunch - VR*. Az alhírforrások név szerint növekvő sorrendbe vannak rendezve. Egy cella bal oldalán egy ikon, annak jobb oldalán a hírforrás neve, a cella végén pedig egy switch található. Kezdetben minden switch ki van kapcsolva. Egy hírforráscsoporthoz a fő hírforrás akkor és csak akkor van bekapcsolva, amikor az összes alhírforrás be van kapcsolva.
	- első képernyő fejlécének jobb oldalán egy next button található, ami továbbnavigál a második képernyőre. A gomb csak akkor aktív, ha legalább 1 switch be van kapcsolva.
	- második képernyője egy név választó és hírforrás megerősítő oldal.
	- második képernyője következő elemeket tartalmazza, középre igazítva:
		1. Egy text field, amivel a hírfolyam nevét lehet megadni. Ez kapja meg a fókuszt a képernyő megnyitásakor (tehát a keyboard is feljön). A fókuszt az enter megnyomásával lehet megszüntetni. Csak 1 sort lehet beírni és legfeljebb 16 karaktert. Fókusz elvesztésekor frissíti a képernyő címét a field tartalmára, ha az valid. Különben pedig a default címet teszi ki a képernyőre.
		2. Az első képernyőn összeválogatott hírforrások felsorolása, megerősítés jeleggel. Egymás alatt vannak felsorolva az elemek, szöveg szerint növekvő sorrendben. Egy elem bal oldalán a hírforrás képe található. A kép jobb oldalán pedig egy cím, ami a hírforrás neve, például *HVG - Itthon, Index, TechCrunch, TechCrunch - Android*, stb.
	- második képernyő fejlécének jobb oldalán egy save button található, ami elmenti a megadott értékek alapján a hírfolyamot és eldobja a képernyőt. A gomb csak akkor aktív, ha valid a név. Mentés után a hírfolyamválasztó lista első helyére kerül a létrehozott hírfolyam.
	- **TODO**: milyen képet mentsünk el egy így létrehozott hírfolyamhoz?
4. A hírfolyam képernyő:
	- csak navigation controlleren keresztül érhető el, ezért mindig van a tetején egy fejléc.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- címe a hírfolyam címe.
	- egy cellája egy hírt reprezentál. A cella tartalmazza a hír címét, leírását és egy képet. A kép a bal oldalon jelenik meg, a két szöveg pedig a kép mellett a jobb oldalon, középre igazítva. Fölül a cím, ami megfelelő stílussal van kiemelve. Alul a leírás, kevésbé figyelemfelhívó stílusban, mint a cím. Legfeljebb 2 sor lehet a cím és 2 sor a leírás. A lista egy elemére kattintva egy show segue visz el a hír képernyőre.
	- listája a szokásos módon frissíthető. **TODO**: mennyi hírt töltsünk be / le, hogy frissítsük?
5. A hír képernyő:
	- csak navigation controlleren keresztül érhető el, ezért mindig van a tetején egy fejléc.
	- fejlécének bal oldalán a default back button található, ami visszanavigál a navigációs stacken.
	- címe a hírfolyam címe.
	- tartalma egy webview, amiben a hír betöltődik.
