// ============================================================================
// PROJEKT: Aparat do warunkowania wechowego + labirynt T dla Drosophila (v3.1)
// v3.1: optymalizacja pod przezroczysty PETG (korpus T, komora treningowa, moduly
//       ramion): cienkie, rownomierne scianki (tp_wall) zamiast pelnych blokow,
//       wszystkie nawisy <= ovh_angle (bez podpor), wymiary otworow, gniazd,
//       kieszeni, szczelin i zlaczy dovetail BEZ ZMIAN wzgledem v3.0.
// TECHNOLOGIA: Druk 3D FDM, dysza 0.4 mm. Bez bibliotek zewnetrznych.
//              Zgodne z OpenSCAD 2021.01+.
// ============================================================================
// LISTA CZESCI DO DRUKU (part = "...")        ilosc  material   orientacja
//  "top_adapter"      TopAdapter            1x    PLA/PETG   podstawa (kolnierz) na stole
//  "plunger_guide_cap" PlungerGuide          1x    PLA        kolnierzem do stolu (opcjonalna)
//  "training_chamber" TrainChamber           1x    PETG przezr. podstawa (kolnierz) na stole
//  "t_body"           TBody                 1x    PETG przezr. podstawa (pas + podkladki stopek) na stole
//  "arm_odor_module"  ArmModule             2x    PETG przezr. lezac na plaskiej stopce (kil) spustu
//  "gate"             Gate (G1, G2)             2x    PLA        na plasko
//  "guillotine"       ArmGuillotine             2x    PLA        na plasko
//  "plunger"          Plunger                   1x    PLA/PETG   pionowo, glowka (kolnierz) na stole
//  "plunger_tip_tpu"  TPUTip                1x    TPU 95A    czolem do stolu
//  Elementy kupne: 4x pret gwintowany M3 (dl. = stack_h + ~8 mm, patrz echo)
//  lub 4x sruba M3 tej dlugosci, 8x nakretka M3, drut Cu, fiolki/rurki (ZMIERZ).
// ============================================================================

/* [Widok i Eksport] */
// Wybierz część do wyrenderowania
part = "print_all"; // ["assembly":Złożenie 3D, "print_all":Wszystkie części obok siebie, "top_adapter":Adapter górny, "plunger_guide_cap":Zatyczka prowadnica, "training_chamber":Komora treningowa, "t_body":Korpus T, "arm_odor_module":Moduł zielony (na rurkę), "gate":Zasuwka pomarańczowa, "guillotine":Gilotyna, "plunger":Tłok strzykawki, "plunger_tip_tpu":Końcówka TPU, "main_foot":Stopka czarnego segmentu, "support":Podpora zielonej tuby]
// Pokaz widok rozstrzelony (rozsuniete czesci)
exploded_view = false; 

/* [Ustawienia Siatki] */
// Rozdzielczość (gładkość okręgów)
$fn = 128; // [16:16:1024]

/* [Wymiary Główne i Otwory] */
// Srednica kanalu pionowego (glowny tunel na strzykawke)
bore_d = 20.0; // [10:0.1:40]
// Srednica zewnetrzna rurek bocznych (przezroczystych)
arm_tube_od = 36.0; // [10:0.1:40]
// Srednica wewnetrzna rurek bocznych
arm_tube_id = 33.4; // [5:0.1:30]
// Srednica otworow wywietrznikowych
vent_d = 6.0; // [2:0.1:20]
// Srednica fiolki zapachowej (os Y, srodek)
train_odor_vial_od = 25.0; // [5:0.1:30]

/* [Zlacze Dovetail] */
// Przesuniecie zlacza wzgledem srodka osi X
dt_offset = 18.15; // [10:0.05:22]
// Szerokosc dolna klina zlacza
dt_w_base = 3.0; // [1:0.1:10]
// Szerokosc gorna klina zlacza
dt_w_top = 4.0; // [1:0.1:10]
// Wysokosc szyny/klina zlacza
dt_h = 2.0; // [0.5:0.1:5]
// Luz (tolerancja) miedzy zenskim a meskim złączem
dt_tol = 0.25; // [0:0.01:1.0]
// Ogranicznik: rowek zabudowany od strony +Y na te dlugosc (modul wsuwa sie od -Y); dotyczy stosu i stopek
dt_stop = 2.0; // [0:0.5:6]

/* [Grubosc scianek] */
// Scianki elementow PRZEZROCZYSTYCH (korpus T, komora treningowa, moduly ramion); zalecane >= 1.2
tp_wall = 0.84; // [0:0.1:4]
// Scianki elementow NIEPRZEZROCZYSTYCH (globalny parametr "wall": scianka miedzy szczelina gilotyny a gniazdem rurki
// w korpusie T, zapas kilu modulu ramienia pod podpore, lozysko podpory). UWAGA: zmiana przesuwa koniec rurki (tube_end_x).
op_wall = 2.0; // [0:0.1:4]
// Grubosc materialu pod rowkiem dovetail / pod kieszenia zasuwki w kolnierzach
tp_flange = 2.5; // [1.6:0.1:5]
// Maksymalny kat nawisu drukowany bez podpor (od poziomu); 45 = bezpiecznie
ovh_angle = 45; // [35:1:60]

/* [Pin centrujacy podpory tuby] */
// Srednica pinu na gornej powierzchni podpory (slot w stopce modulu ramienia liczy sie z tego)
support_pin_d = 4.0; // [1:0.1:10]
// Wysokosc pinu = glebokosc slotu w stopce (plus luz dna)
support_pin_h = 5.0; // [0.5:0.1:10]
// Luz promieniowy slotu wzgledem pinu (srednica slotu = pin + 2 * luz)
support_pin_tol = 0.15; // [0:0.05:0.5]
// Luz dna slotu (slot glebszy od pinu o te wartosc)
support_pin_bottom_gap = 0.3; // [0:0.1:1]

/* [Stópki i Podpory (Nowe)] */
feet_h = 25.0; // [5:1:50] Wysokosc stopek
feet_thick = 15.0; // [5:1:40] Szerokosc (grubosc) stopek w osi X
feet_angle = 45.0; // [0:1:70] Kat nachylenia bocznego (od pionu)
feet_len_y = 88.0; // [44:1:120] Dlugosc stopki na podlozu w osi Y
feet_dt_offset = 25.0; // [10:1:50] Przesuniecie prowadnic stopek pod glownym segmentem
feet_dt_w_base = 6.0; // [2:0.1:15] Szerokosc dolna zlacza stopki
feet_dt_w_top = 8.0; // [2:0.1:20] Szerokosc gorna zlacza stopki
feet_dt_h = 3.0; // [1:0.1:10] Wysokosc szyny stopki
feet_dt_tol = 0.25; // [0:0.01:1] Luz zlacza stopki
support_arm_w = 15.0; // [5:1:40] Szerokosc nakladki na tube (w osi X)
support_arm_t = 3.0; // [0:0.1:10] Grubosc nakladki (lozyska) podpory; 0 = uzyj op_wall
support_pos_x = 35.0; // [10:1:80] Pozycja podpory na zielonej tubie (od poczatku tuby)

/* [Hidden] */
gates_open      = [true, true, true, true]; // [G1, G2, gilotyna lewa, gilotyna prawa]
plunger_pos     = 0.0;        // 0 = tlok wyjety do gory, 1 = tlok na ograniczniku
show_vials      = true;       // polprzezroczyste modele kupnych fiolek i rurek
show_collisions = false;      // tryb diagnostyczny: rysuje przeciecia par czesci
inspection_windows = false;   // okienka podgladowe - v3.1: bez efektu (przezroczyste powloki tp_wall juz sa cienkie)
flush_vent      = true;       // otwor wylotowy do wyplukania zapachu z komory treningowej
spacing = exploded_view ? 30 : 0;

top_vial_od    = 36.0;         // ZMIERZ przed drukiem: kolba z muchami, srednica zewn. szyjki
top_vial_depth = 20.0;         // ZMIERZ przed drukiem: glebokosc osadzenia kolby
train_odor_vial_depth = 16.0;  // ZMIERZ przed drukiem
arm_tube_len  = 80.0;          // ZMIERZ przed drukiem: dlugosc rurki
arm_tube_depth = 10.0;         // glebokosc osadzenia rurki w gniazdach (korpus T i modul zielony)
arm_odor_vial_od    = 25.0;    // ZMIERZ przed drukiem: fiolka zapachowa na koncu ramienia
arm_odor_vial_depth = 16.0;    // ZMIERZ przed drukiem

fit_tol   = 0.3;   // pasowanie suwliwe (zasuwki, gilotyny, fiolki, rurki)
press_tol = 0.2;   // pasowanie wciskane (korki, czopy centrujace)
gate_t    = 2.4;   // grubosc plytek zasuwek i gilotyn (12 warstw po 0.2)
tip_clearance = 0.4; // luz srednicowy koncowki TPU w kanale
mesh_hole_d = 1.0; // otwory sitek (mucha nie przejdzie)
mesh_bridge = 0.9; // mostek miedzy otworami sitka (>= 2 szerokosci linii)
mesh_t      = 1.6; // grubosc scianki sitka
wall  = op_wall;   // minimalna grubosc scianki elementow nieprzezroczystych (alias op_wall)
frame_w  = 44.0;   // bok kwadratowego kolnierza stosu
tc_h     = 50.0;   // wysokosc komory treningowej
drain_d  = 12.0;   // srednica spustow w modulach zielonych (>= 10-12 mm)
rib_w    = 2.6;    // grubosc zeber trzonu tloka (plus)
rib_span = bore_d - 6; // rozpietosc zeber tloka
tip_h    = 8.0;    // wysokosc koncowki TPU
tip_concave = 0.0; // wkleslosc czola TPU (0 = plaskie, latwiejszy druk)
win_w = 3.0; win_wall = 0.6; // okienko: szerokosc, grubosc cienkiej scianki
teardrop_cap = 2.0; // sciecie szczytu kropli (mostek <= ~5 mm, drukuje sie bez podpor)

// --- 4. WYMIARY WYNIKOWE (nie edytowac, wszystko liczy sie z powyzszych) ----
// Zasuwki poziome G1/G2 ("kanapka": kieszen w gornej powierzchni nizszego modulu)
slot_h     = gate_t + 2 * fit_tol;   // glebokosc kieszeni
gate_w     = bore_d + 8;             // plytka: 4 mm zakladki poza kanal z kazdej strony
slot_w     = gate_w + 2 * fit_tol;   // szerokosc kieszeni
gate_travel = bore_d + 2;            // skok otwarte->zamkniete (2 mm zakladki)
gate_hc    = frame_w / 2;            // srodek otworu plytki liczac od uchwytu
gate_len   = frame_w + gate_travel;  // dlugosc plytki do zaczepu koncowego
m3_off  = frame_w / 2 - 4;           // otwory M3 w narozach
pin_off = m3_off;                    // czopy centrujace na osi X (poza kieszenia zasuwki)
// Korpus T / komora startowa
z_floor = 12.0;                   // dno komory = wierzch korka srodkowego
z_arm   = z_floor + arm_tube_id / 2;         // os rurek ramion (dol wylotu = dno komory)
cap_flange_t = 3.0;                          // grubosc kolnierza zatyczki-prowadnicy tloka
z_stop  = z_arm + arm_tube_id / 2 + cap_flange_t; // strop komory startowej = dolna pozycja tloka
tb_h    = z_stop + slot_h + 3;               // wysokosc korpusu T (kieszen G2 w jego wierzchu)
guil_slot_w  = gate_t + 2 * fit_tol;              // szczelina gilotyny (grubosc)
guil_x     = frame_w / 2 + 2 + guil_slot_w / 2;      // os gilotyny: poza obrysem komory treningowej
tube_end_x    = guil_x + guil_slot_w / 2 + wall;           // koniec wsunietej rurki ramienia
tbody_hx = tube_end_x + arm_tube_depth;           // polowa szerokosci korpusu T (os X)
guil_w  = arm_tube_id + 4;                   // plytka gilotyny: 2 mm zakladki
guil_base_z    = z_arm - arm_tube_id / 2;       // dno szczeliny gilotyny (idealnie rowno z dnem rurki)
guil_lift = arm_tube_id + 4;                 // podniesienie = pelne otwarcie
guil_h  = tb_h - guil_base_z + 2;                   // wysokosc plytki (bez uchwytu)
guil_detent_z = tb_h - 3;                       // wysokosc zapadki gilotyny
// Adapter gorny
top_sock_d = top_vial_od + 2 * fit_tol;
funnel_h = (top_sock_d - bore_d) / 2;      // lejek 45 st.
ta_base  = 8.0;                              // dolna czesc adaptera (kanal bore_d, czopy, M3)
ta_h     = ta_base + funnel_h + top_vial_depth;
Z1 = tb_h; Z2 = tb_h + tc_h; Z_top = Z2 + ta_h; // poziomy polaczen stosu
stack_h = Z_top;
// Tlok
tip_d   = bore_d - tip_clearance;
disc_d  = bore_d - 2; disc_t = 3.0;
stud_d  = 6.0; stud_h = 3.0; stud_head_d = 8.5; stud_head_h = (stud_head_d - (stud_d - 1)) / 2;
collar_d = 30.0; collar_t = 8.0;             // kolnierz-ogranicznik = glowka pod kciuk
z_collar = Z_top + cap_flange_t;             // spod kolnierza opiera sie o zatyczke-prowadnice
rod_len  = z_collar - z_stop - tip_h - disc_t;
plunger_len = tip_h + disc_t + rod_len + collar_t; // z koncowka TPU
marker_1 = (Z1 + slot_h + 1) - z_stop;       // karb: koncowka nad G2 (mozna zamknac G2)
marker_2 = (Z2 + slot_h + 1) - z_stop;       // karb: koncowka nad G1 (mozna zamknac G1)
// Modul zapachowy ramienia
arm_sock_d  = arm_tube_od + 2 * fit_tol;
arm_vial_d  = arm_odor_vial_od + 2 * fit_tol;
arm_mod_R   = max(arm_sock_d, arm_vial_d) / 2 + teardrop_cap + wall; // odleglosc osi od stopki (kilu) modulu = polowa wysokosci; jak w v3.0
arm_fly_len = drain_d + 4;                   // komora much nad spustem
arm_l0 = arm_tube_depth; arm_l1 = arm_l0 + arm_fly_len; arm_l2 = arm_l1 + mesh_t;
arm_l3 = arm_l2 + arm_odor_vial_depth;         // dlugosc modulu
arm_x0 = tube_end_x + arm_tube_len - arm_tube_depth; // wewnetrzne czolo modulu zielonego
x_drain = arm_x0 + arm_l0 + arm_fly_len / 2;    // os spustu ramienia
// Komora treningowa
train_sock_d = train_odor_vial_od + 2 * fit_tol;
odor_boss_len = max(0, bore_d / 2 + mesh_t + train_odor_vial_depth + 1 - frame_w / 2);
// --- Powloki elementow przezroczystych (v3.1) ---
// Korpus T: scianka tp_wall wokol przelotu ramienia / gniazda rurki, pas podstawy, wieze gilotyn
tb_shell_R  = arm_tube_id / 2 + tp_wall;      // promien zewn. powloki wokol przelotu rurki
tb_boss_R   = arm_sock_d / 2 + tp_wall;       // promien zewn. mufy gniazda rurki
tb_base_hw  = bore_d / 2 + tp_wall;           // polowa szerokosci plaskiego pasa podstawy (os Y)
tb_tower_hw = guil_slot_w / 2 + tp_wall;      // polowa grubosci wiezy gilotyny (os X)
tb_pad_h    = feet_dt_h + feet_dt_tol + tp_flange; // podkladka pod rowek stopki
z_bore_top  = z_arm + arm_tube_id / 2;        // strop przelotu ramienia = spod plyty gornej korpusu T
// Komora treningowa: rura wokol kanalu + dwa kolnierze 44x44 (dolny: rowki, gorny: kieszen G1 + szyny)
tc_tube_od  = bore_d + 2 * tp_wall;
tc_fl_bot   = dt_h + dt_tol + tp_flange;      // kolnierz dolny
tc_fl_top   = slot_h + tp_flange;             // plyta gorna (dno kieszeni G1 = tp_flange)
tc_skirt_h  = (frame_w / sqrt(2) - tc_tube_od / 2) * tan(ovh_angle); // pusta spodnica pod plyta gorna
tc_boss_d   = train_sock_d + 2 * tp_wall;     // boss gniazda fiolki zapachowej (+Y)
tc_vent_boss_d = vent_d + 2 * tp_wall;        // boss wylotu plukania (-Y)
tc_vent_boss_len = 4.0;                       // wysuniecie bossa wylotu poza rure
// Modul ramienia: dwie sekcje o roznym promieniu + wspolny plaski kil (stopka do druku)
arm_R_A = arm_sock_d / 2 + tp_wall;           // sekcja mufa + komora much (0..arm_l2)
arm_R_B = arm_vial_d / 2 + tp_wall;           // sekcja gniazda fiolki (arm_step..arm_l3)
arm_step = arm_l1 + 1.0;                      // uskok srednicy zewn.: 1 mm za komora much, w obrebie sitka (otwory sitka <= r 11)
function arm_foot_w(r) = max(r * sqrt(2) - arm_mod_R, drain_d / 2 + 1); // polowa szer. stopki: kil >= 45 st.
function arm_R_at(pos) = pos < arm_step ? arm_R_A : arm_R_B;

// Kolory (jak w v2.0)
c_body    = [0.20, 0.22, 0.25, 1.0];  // grafit: korpus, komory
c_sliders = [0.90, 0.40, 0.15, 1.0];  // pomaranczowy: zasuwki, gilotyny
c_odor    = [0.20, 0.70, 0.40, 0.90]; // zielony: moduly zapachowe
c_plunger = [0.85, 0.85, 0.80, 1.0];  // tlok
c_tpu     = [0.30, 0.30, 0.35, 1.0];  // koncowka TPU
c_ref     = [0.75, 0.88, 0.98, 0.35]; // referencyjne fiolki/rurki

// ============================================================================
// --- 5. POMOCNICZE PRYMITYWY ------------------------------------------------
// ============================================================================
// Siatka otworow sitka (wzdluz lokalnego Z) w kole o promieniu r_area.
// max_x: opcjonalne ograniczenie |x| otworow (sitko na krzywej sciance kanalu: otwory dalej od osi
// kanalu niz promien kanalu minus polowa otworu nie trafilyby do kanalu, tylko slepo w scianke).
module MeshHoles(r_area, len, max_x = 1e9) {
    p = mesh_hole_d + mesh_bridge;
    n = floor(r_area / p);
    for (ix = [-n : n], iy = [-n : n])
        if (norm([ix * p, iy * p]) <= r_area - mesh_hole_d / 2 && abs(ix * p) <= max_x)
            translate([ix * p, iy * p, 0]) cylinder(d = mesh_hole_d, h = len, $fn = 12);
}

// Przekroj "plus" trzonu tloka
module CrossProfile(extra = 0) {
    square([rib_span + 2 * extra, rib_w + 2 * extra], center = true);
    square([rib_w + 2 * extra, rib_span + 2 * extra], center = true);
}

// Odbicie wzgledem plaszczyzny YZ dla s = -1, bez odbicia dla s = +1
module MirrorX(s) { if (s < 0) mirror([1, 0, 0]) children(); else children(); }

// Prostopadloscian kolnierza stosu (os Z od 0)
module Block(h, wx = frame_w, wy = frame_w) translate([-wx / 2, -wy / 2, 0]) cube([wx, wy, h]);

// Zastępuje otwory M3 i czopy: system dovetail dla łączenia modułów bez śrub
module DovetailProfile(tol=0, base_y=0) polygon([ [-(dt_w_base/2 + tol), base_y], [(dt_w_base/2 + tol), base_y], [(dt_w_top/2 + tol), dt_h + tol], [-(dt_w_top/2 + tol), dt_h + tol] ]);
module DovetailGrooves() for (sx = [-1, 1]) translate([sx * dt_offset, frame_w/2 - dt_stop, 0]) rotate([90, 0, 0]) linear_extrude(frame_w) DovetailProfile(dt_tol, -0.01);
module DovetailRails(h) for (sx = [-1, 1]) translate([sx * dt_offset, frame_w/2 - dt_stop, h]) rotate([90, 0, 0]) linear_extrude(frame_w - dt_stop) DovetailProfile(0, 0);
// Kieszen zasuwki w gornej powierzchni modulu (przelotowa wzdluz Y)
module GatePocket(h) translate([-slot_w / 2, -frame_w / 2 - 1, h - slot_h]) cube([slot_w, frame_w + 2, slot_h + 1]);
// Wybrzuszenie zapadki na +X scianie kieszeni (wchodzi 0.2 mm w tor plytki)
module GateDetent(h) translate([slot_w / 2, 0, h - slot_h]) cylinder(d = 1.0, h = slot_h - 0.3, $fn = 16);
// Okienko podgladowe: cienka przeswitujaca scianka (win_wall) + wpust 1.2 mm na pasek PET.
// Nie zostawia otworu (scianka zostaje), wiec mucha nie ucieknie nawet bez szybki.
module InspectionWindow(hw, z0, z1) {   // w scianie +X
    translate([bore_d / 2 + win_wall, -win_w / 2, z0]) cube([hw, win_w, z1 - z0]);
    translate([hw - 1.2, -(win_w + 4) / 2, z0 - 2]) cube([2, win_w + 4, z1 - z0 + 4]);
}

// Profil 2D "kil": okrag o promieniu r + plaska stopka w odleglosci foot_x od osi
// (w kierunku +X), o polowie szerokosci foot_w. Boki stopki schodza do okregu
// stycznie, pod katem >= 45 st. (arm_foot_w), wiec lezac na stopce drukuje sie bez podpor.
module KeelProfile(r, foot_x, foot_w) hull() {
    circle(r = r);
    translate([foot_x - 0.01, -foot_w]) square([0.01, 2 * foot_w]);
}
// Profil zewnetrzny modulu ramienia w pozycji pos wzdluz osi (lokalnie: +X = stopka/spust)
module ArmProfile2D(pos) KeelProfile(arm_R_at(pos), arm_mod_R, arm_foot_w(arm_R_at(pos)));
// Profil YZ korpusu T (2D: x = Y swiata, y = Z swiata): okrag powloki wokol osi rurki,
// plaski pas podstawy na Z=0 i (opcjonalnie) pelna plyta gorna 44 mm od stropu przelotu.
// Hull daje boki nachylone > 70 st. od poziomu - bez nawisow.
module TBodyShellProfile(r_circ, with_top = true) hull() {
    translate([0, z_arm]) circle(r = r_circ);
    translate([-tb_base_hw, 0]) square([2 * tb_base_hw, 0.01]);
    if (with_top) translate([-frame_w / 2, z_bore_top]) square([frame_w, tb_h - z_bore_top]);
}
// Wytloczenie profilu YZ wzdluz osi X (od x0 na dlugosci len)
module AlongX(x0, length) translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(length) children();
// Spodnica: hull kwadratu w x w (spod plyty na z_top) i okregu d na wysokosci z_top - h
module Skirt(z_top, h, w, d) hull() {
    translate([0, 0, z_top - 0.01]) Block(0.01, w, w);
    translate([0, 0, z_top - h]) cylinder(d = d, h = 0.01);
}

// ============================================================================
// --- 6. MODULY DO DRUKU -----------------------------------------------------
// ============================================================================

// ----------------------------------------------------------------------------
// TopAdapter(): adapter gornej kolby. Lokalnie Z=0..ta_h. DRUK: podstawa na stole.
// Gniazdo kolby od gory, lejek 45 st. do bore_d, na dole gniazda czopow i M3.
// Spod adaptera przykrywa kieszen zasuwki G1 w komorze treningowej.
// ----------------------------------------------------------------------------
module TopAdapter() {
    difference() {
        Block(ta_h);
        translate([0, 0, -1]) cylinder(d = bore_d, h = ta_base + 2);
        translate([0, 0, ta_base - 0.01]) cylinder(d1 = bore_d, d2 = top_sock_d, h = funnel_h + 0.02);
        translate([0, 0, ta_base + funnel_h - 0.01]) cylinder(d = top_sock_d, h = top_vial_depth + 1);
        DovetailGrooves();
    }
}

// ----------------------------------------------------------------------------
// PlungerGuide(): zatyczka-prowadnica wkladana w gniazdo kolby zamiast kolby.
// Lokalnie: kolnierz Z=0..cap_flange_t, czop w dol. DRUK: kolnierzem do stolu.
// ----------------------------------------------------------------------------
module PlungerGuide(split = false) {
    module CapSolid() {
        difference() {
            union() {
                translate([0, 0, -top_vial_depth]) cylinder(d = top_vial_od, h = top_vial_depth + 0.01);
                cylinder(d = top_sock_d + 8, h = cap_flange_t);
            }
            translate([0, 0, -top_vial_depth - 1])
                linear_extrude(top_vial_depth + cap_flange_t + 2) CrossProfile(fit_tol);
        }
    }
    
    if (!split) CapSolid();
    else {
        for (s = [-1, 1]) translate([0, s * (top_sock_d/2 + 2), 0])
            difference() {
                CapSolid();
                translate([-50, s == 1 ? -50 : 0, -50]) cube([100, 50, 100]);
            }
    }
}

// ----------------------------------------------------------------------------
// TrainChamber(): komora treningowa (komora 1). Lokalnie Z=0..tc_h.
// v3.1 (PETG przezroczysty): rura o sciance tp_wall wokol kanalu zamiast pelnego
// bloku 44x44. Kolnierz dolny 44x44 (rowki dovetail), plyta gorna 44x44 (kieszen
// G1, szyny dovetail, powierzchnia pod adapter) podparta PUSTA spodnica o nachyleniu
// ovh_angle (pelne 45 st. w narozach). Boss gniazda zapachowego (+Y) okragly, z
// przypora 45+ st. do kolnierza dolnego; wylot plukania (-Y) w malym bossie.
// DRUK: podstawa na stole, bez podpor. Wymiary otworow/gniazd/kieszeni jak w v3.0.
// ----------------------------------------------------------------------------
module TrainChamber() {
    zc  = tc_h / 2;
    zpb = tc_h - tc_fl_top;                       // spod plyty gornej
    y_boss_end = frame_w / 2 + odor_boss_len;     // czolo bossa gniazda zapachowego (jak w v3.0)
    y_tube = tc_tube_od / 2;
    difference() {
        union() {
            Block(tc_fl_bot);                                       // kolnierz dolny (rowki dovetail)
            cylinder(d = tc_tube_od, h = tc_h);                    // rura komory
            translate([0, 0, zpb]) Block(tc_fl_top);                // plyta gorna (kieszen G1, szyny)
            difference() {                                          // pusta spodnica pod plyta gorna
                Skirt(zpb, tc_skirt_h, frame_w, tc_tube_od + 0.2);
                Skirt(zpb, tc_skirt_h - tp_wall * sqrt(2), frame_w - 2 * tp_wall * sqrt(2), tc_tube_od - 1);
            }
            DovetailRails(tc_h);
            // boss gniazda fiolki zapachowej (+Y): walec + przypora do kolnierza dolnego (nawis ~57 st.).
            // Boss zaczyna sie w OSI rury (y = 0), bo jest szerszy od rury: dzieki temu klin miedzy wypukla
            // scianka rury a plaska tylna sciana bossa jest wypelniony i sitko (MeshHoles) przechodzi przez pelny material.
            hull() {
                translate([0, y_boss_end - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = tc_boss_d, h = 0.01);
                translate([0, 0, zc]) rotate([-90, 0, 0]) cylinder(d = tc_boss_d, h = 0.01);
                translate([-tc_boss_d / 2, 0, 0]) cube([tc_boss_d, frame_w / 2, 0.01]);
            }
            // boss wylotu plukania (-Y): krotki walec ze sciecem 45 st. od spodu, tez od osi rury (pelne sitko)
            if (flush_vent) mirror([0, 1, 0]) hull() {
                translate([0, y_tube + tc_vent_boss_len - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = tc_vent_boss_d, h = 0.01);
                translate([0, 0, zc]) rotate([-90, 0, 0]) cylinder(d = tc_vent_boss_d, h = 0.01);
                translate([0, 0, zc - tc_vent_boss_len - y_tube]) rotate([-90, 0, 0]) cylinder(d = tc_vent_boss_d, h = 0.01);
            }
        }
        // Kompletnie gladki tunel glowny bez żebrowania na elektrody
        translate([0, 0, -1]) cylinder(d = bore_d, h = tc_h + 2);

        // gniazdo fiolki zapachowej (+Y): srednica, polozenie i glebokosc osadzenia jak w v3.0
        translate([0, bore_d / 2 + mesh_t, zc]) rotate([-90, 0, 0]) cylinder(d=train_sock_d, h=frame_w);
        // Sitko o stalej grubosci mesh_t: dno gniazda pod fiolka jest wspolosiowe z kanalem (powloka
        // r = bore_d/2 + mesh_t), a nie plaskie - inaczej przy brzegach scianka mialaby kilka mm.
        // Kieszen siega od y = bore_d/2 - 2 do dotychczasowego dna; fiolka nadal opiera sie na y = bore_d/2 + mesh_t.
        difference() {
            translate([0, bore_d / 2 - 2, zc]) rotate([-90, 0, 0]) cylinder(d = train_sock_d, h = mesh_t + 2 + 0.01);
            translate([0, 0, -1]) cylinder(d = bore_d + 2 * mesh_t, h = tc_h + 2);
        }
        // Otwory sitka: od osi kanalu (y = 0) na wylot przez powloke, tylko tam, gdzie trafiaja w kanal
        // (|x| <= bore_d/2 - mesh_hole_d/2 - 1); kazdy otwor laczy kanal z gniazdem, zadnych slepych.
        translate([0, 0, zc]) rotate([-90, 0, 0])
            MeshHoles(train_odor_vial_od / 2 - 1.5, bore_d / 2 + mesh_t + 2, bore_d / 2 - mesh_hole_d / 2 - 1);
        // wylot plukania (-Y), tez z sitkiem; otwor siega tylko przez bossa (nie wchodzi do pustej spodnicy)
        if (flush_vent) mirror([0, 1, 0]) {
            translate([0, bore_d / 2 + mesh_t, zc]) rotate([-90, 0, 0]) cylinder(d=vent_d, h=y_tube + tc_vent_boss_len + 1 - (bore_d / 2 + mesh_t));
            translate([0, 0, zc]) rotate([-90, 0, 0]) MeshHoles(vent_d / 2 - 0.5, bore_d / 2 + mesh_t + 2, bore_d / 2 - mesh_hole_d / 2 - 1);
        }
        GatePocket(tc_h);
        DovetailGrooves();
        // inspection_windows: nieaktualne dla przezroczystej rury o sciance tp_wall (brak wyciecia)
    }
    GateDetent(tc_h);
}

// ----------------------------------------------------------------------------
// TBody(): korpus labiryntu T z komora startowa (komora 2).
// Lokalnie Z=0..tb_h, X = +-tbody_hx, Y = +-frame_w/2. DRUK: podstawa na stole.
// v3.1 (PETG przezroczysty): zamiast pelnego bloku 78x44x54:
//  - powloka o sciance tp_wall wokol przelotu rurek (|x| <= tube_end_x) z pelna plyta
//    gorna 44 mm (od stropu przelotu do wierzchu: kieszen G2, szyny, oparcie komory),
//  - mufy gniazd rurek (tube_end_x..tbody_hx) o sciance tp_wall,
//  - plaski pas podstawy (szer. 2*tb_base_hw) na calej dlugosci = tuleja korka + stabilny druk,
//  - wieze gilotyn: pelna wysokosc i szerokosc 44 wokol szczelin (zapadki u gory),
//  - podkladki 44 x feet_thick pod rowki dovetail stopek.
// Boki powloki nachylone > 70 st. od poziomu: zadnych nawisow, zadnych podpor.
// Gilotyny leza POZA obrysem komory treningowej (guil_x > frame_w/2), zeby dalo sie
// je podnosic od gory przy zlozonym stosie; szczelina lezy miedzy komora startowa
// a koncem wsunietej rurki (tube_end_x). Kieszen G2 w wierzchu. Dno komory = korek srodkowy.
// ----------------------------------------------------------------------------
module TBody() {
    difference() {
        union() {
            AlongX(-tube_end_x, 2 * tube_end_x) TBodyShellProfile(tb_shell_R, true);          // powloka srodkowa + plyta gorna
            for (s = [-1, 1]) MirrorX(s)
                AlongX(tube_end_x - 0.01, tbody_hx - tube_end_x + 0.01) TBodyShellProfile(tb_boss_R, false); // mufy gniazd rurek
            for (s = [-1, 1]) translate([s * guil_x - tb_tower_hw, -frame_w / 2, 0])
                cube([2 * tb_tower_hw, frame_w, tb_h]);                                         // wieze gilotyn
            for (s = [-1, 1]) translate([s * feet_dt_offset - feet_thick / 2, -frame_w / 2, 0])
                cube([feet_thick, frame_w, tb_pad_h]);                                           // podkladki stopek
            DovetailRails(tb_h);
        }
        translate([0, 0, -1]) cylinder(d = bore_d, h = tb_h + 2);     // kanal + komora + gniazdo korka
        for (s = [-1, 1]) MirrorX(s) translate([0, 0, z_arm]) {
            rotate([0, 90, 0]) cylinder(d=arm_tube_id, h=tube_end_x + 0.01);                       // przelot do rurki (idealnie okragly)
            translate([tube_end_x, 0, 0]) rotate([0, 90, 0]) cylinder(d=arm_sock_d, h=tbody_hx); // gniazdo rurki z kolnierzem oporowym (idealnie okragle)
        }
        for (s = [-1, 1]) translate([s * guil_x, 0, z_arm]) {
            // Gorna czesc szczeliny - prowadnice prostokatne dla szerszej czesci gilotyny (od osi rurki w gore)
            // Dolna polowa rurki pozostaje nienaruszona - gilotyna wsunie sie prosto w jej naturalne zaokraglone dno bez zadnego schodka
            translate([-guil_slot_w / 2, -(guil_w + 2 * fit_tol) / 2, 0]) cube([guil_slot_w, guil_w + 2 * fit_tol, tb_h - z_arm + 1]);
        }
        GatePocket(tb_h);
        FeetDovetailGrooves();
        // inspection_windows: nieaktualne dla przezroczystej powloki o sciance tp_wall (brak wyciecia)
    }
    GateDetent(tb_h);
    // zapadki gilotyn: wybrzuszenie na +Y scianie szczeliny, male poziome walce
    for (s = [-1, 1]) translate([s * guil_x, (guil_w + 2 * fit_tol) / 2, guil_detent_z])
        rotate([0, 90, 0]) cylinder(d = 1.0, h = guil_slot_w - 0.3, center = true, $fn = 16);
}

// ----------------------------------------------------------------------------
// ArmModule(): zielony modul na koncu rurki ramienia. Lokalnie os = +Z
// (0 = czolo od strony aparatu), krociec spustowy ku +X. W swiecie obracany tak,
// ze os = +X, spust w dol; prawy = orientacja druku (lezy na stopce krocca).
// Kolejnosc od aparatu: mufa na rurke -> komora much ze spustem -> sitko ->
// gniazdo na fiolke zapachowa (otwarte na zewnatrz).
// v3.1 (PETG przezroczysty): zamiast pelnego walca R=arm_mod_R dwie sekcje o sciance
// tp_wall (arm_R_A wokol mufy/komory much, arm_R_B wokol gniazda fiolki) na wspolnym
// plaskim kilu (stopce) w odleglosci arm_mod_R od osi - stad lezy plasko na stole
// (jak w v3.0), spust i otwor pinu podpory wychodza w stopce, boki kilu >= 45 st.
// ----------------------------------------------------------------------------
module ArmModule() {
    difference() {
        union() {
            linear_extrude(arm_step + 0.01) ArmProfile2D(0);                              // mufa + komora much (+ poczatek sitka)
            translate([0, 0, arm_step]) linear_extrude(arm_l3 - arm_step) ArmProfile2D(arm_l3); // sitko + gniazdo fiolki
        }
        translate([0, 0, -1]) cylinder(d=arm_sock_d, h=arm_l0 + 1);          // mufa, kolnierz oporowy na arm_l0
        translate([0, 0, arm_l0 - 0.01]) cylinder(d=arm_tube_id, h=arm_fly_len + 0.02); // komora much
        translate([0, 0, arm_l1 - 1]) MeshHoles(min(arm_tube_id, arm_odor_vial_od) / 2 - 1.5, mesh_t + 2); // sitko
        translate([0, 0, arm_l2]) cylinder(d=arm_vial_d, h=arm_l3);            // gniazdo fiolki zapachowej
        translate([0, 0, arm_l0 + arm_fly_len / 2]) rotate([0, 90, 0]) cylinder(d = drain_d, h = arm_mod_R + 10); // spust
        // Slot na pin centrujacy podpory: w stopce, glebokosc = support_pin_h + luz dna, srednica = pin + 2 * luz
        translate([arm_mod_R - support_pin_h - support_pin_bottom_gap, 0, support_pos_x]) rotate([0, 90, 0])
            cylinder(d = support_pin_d + 2 * support_pin_tol, h = support_pin_h + support_pin_bottom_gap + 1, $fn = 32);
    }
}
// Ustawienie modulu w swiecie (prawe ramie); lewe = mirror([1,0,0])
module ArmModulePlaced() translate([arm_x0, 0, z_arm]) rotate([0, 90, 0]) ArmModule();

// ----------------------------------------------------------------------------
// Gate(): zasuwka pozioma G1/G2. Lokalnie: plytka X=+-gate_w/2, Y=0..gate_len,
// Z=0..gate_t; uchwyt na Y<0, zaczep koncowy za gate_len. DRUK: na plasko.
// Wklada sie ja do otwartej kieszeni PRZED nalozeniem wyzszego modulu (dlatego
// oba konce moga byc wyzsze od kieszeni). Wsunieta do oporu (uchwyt o sciane -Y)
// = OTWARTE, otwor w osi kanalu. Wyciagnieta o gate_travel (zaczep o sciane +Y)
// = ZAMKNIETE. Karby na krawedzi +X wspolpracuja z wybrzuszeniem w kieszeni.
// ----------------------------------------------------------------------------
module Gate() {
    difference() {
        union() {
            translate([-gate_w / 2, 0, 0]) cube([gate_w, gate_len, gate_t]);
            translate([-(gate_w + 6) / 2, -4, 0]) cube([gate_w + 6, 4, gate_t + 3]);  // uchwyt = ogranicznik "otwarte"
            translate([-gate_w / 2, gate_len, 0]) cube([gate_w, 2, gate_t + 2]);        // zaczep = ogranicznik "zamkniete"
        }
        translate([0, gate_hc, -1]) cylinder(d = bore_d, h = gate_t + 2);
        for (y = [gate_hc, gate_hc + gate_travel]) translate([gate_w / 2, y, -1]) cylinder(d = 1.2, h = gate_t + 2, $fn = 16);
    }
}
// Ustawienie zasuwki w kieszeni modulu o wierzchu z_top
module GatePlaced(z_top, open) translate([0, -frame_w / 2 - (open ? 0 : gate_travel), z_top - slot_h + fit_tol]) Gate();

// ----------------------------------------------------------------------------
// ArmGuillotine(): gilotyna pionowa. Lokalnie na plasko: X = szerokosc (swiat Y),
// Y = wysokosc (swiat Z), Z = grubosc (swiat X). Uchwyt T u gory. DRUK: na plasko.
// Opuszczona do dna szczeliny = ZAMKNIETE (zakrywa wylot z zakladka 2 mm),
// podniesiona o guil_lift = OTWARTE; karby na krawedzi +X trzymaja obie pozycje.
// ----------------------------------------------------------------------------
module ArmGuillotine() {
    difference() {
        union() {
            // Glowna plytka z zaokraglonym dnem idealnie pasujacym do przekroju rurki
            linear_extrude(gate_t) {
                union() {
                    translate([0, arm_tube_id / 2]) circle(d = arm_tube_id);
                    translate([-guil_w / 2, arm_tube_id / 2]) square([guil_w, guil_h - arm_tube_id / 2]);
                }
            }
            // Uchwyt T
            translate([-(guil_w + 8) / 2, guil_h, 0]) cube([guil_w + 8, 5, gate_t + 2]);
        }
        for (sx = [-1, 1]) {
            for (y = [guil_detent_z - guil_base_z, guil_detent_z - guil_base_z - guil_lift])
                translate([sx * guil_w / 2, y, -1]) cylinder(d = 1.2, h = gate_t + 4, $fn = 16);
        }
    }
}
module GuillotinePlaced(side, open)
    translate([side * guil_x, 0, guil_base_z + (open ? guil_lift : 0)])
    rotate([0, 0, side < 0 ? 180 : 0])
    translate([-gate_t / 2, 0, 0])
    rotate([90, 0, 90]) ArmGuillotine();



// ----------------------------------------------------------------------------
// Plunger(): tlok (zastepuje winde). Lokalnie Z=0 = czolo koncowki TPU.
// Trzon o przekroju "plus" (nie trze o scianki ani druciki), na dole tarcza
// z czopem grzybkowym pod koncowke TPU, na gorze kolnierz-ogranicznik (zarazem
// glowka pod kciuk), ktory opiera sie o zatyczke-prowadnice dokladnie wtedy, gdy
// czolo jest na stropie komory startowej (z_stop). Karby: koncowka nad G2 / nad G1.
// DRUK: pionowo, glowka na stole: plaska, szeroka podstawa; jedyne nawisy to
// stozek 45 st. pod tarcza i 1.25 mm pierscien pod grzybkiem (krotki mostek, OK).
// Lezac na boku tarcza i glowka wymagalyby podpor, dlatego pionowo.
// ----------------------------------------------------------------------------
module Plunger() {
    z0 = tip_h;                       // spod tarczy nosnej
    zc = z0 + disc_t + rod_len;       // spod kolnierza-ogranicznika
    translate([0, 0, z0]) cylinder(d = disc_d, h = disc_t);
    translate([0, 0, z0 + disc_t - 0.01]) cylinder(d1 = disc_d, d2 = rib_span, h = (disc_d - rib_span) / 2);
    translate([0, 0, z0 - stud_h]) cylinder(d = stud_d, h = stud_h + 0.01);
    translate([0, 0, z0 - stud_h - stud_head_h]) cylinder(d1 = stud_d - 1, d2 = stud_head_d, h = stud_head_h + 0.01);
    
    // Gładki trzon w ksztalcie plusa, bez zadnych nacięć
    translate([0, 0, z0 + disc_t - 0.01]) linear_extrude(rod_len + 0.02) CrossProfile();
    
    translate([0, 0, zc]) cylinder(d = collar_d, h = collar_t);
}

// ----------------------------------------------------------------------------
// TPUTip(): koncowka TPU. Lokalnie Z=0 = czolo. Srednica bore_d - tip_clearance,
// fazka 1 mm na krawedzi czola, gniazdo grzybka od gory, 6 mikrootworow
// odpowietrzajacych (<= mesh_hole_d). DRUK: czolem do stolu (TPU, bez podpor).
// ----------------------------------------------------------------------------
module TPUTip() {
    difference() {
        union() {
            cylinder(d1 = tip_d - 2, d2 = tip_d, h = 1);
            translate([0, 0, 0.99]) cylinder(d = tip_d, h = tip_h - 0.99);
        }
        translate([0, 0, tip_h - stud_h]) cylinder(d = stud_d, h = stud_h + 1);
        translate([0, 0, tip_h - stud_h - stud_head_h])
            cylinder(d1 = stud_d - 1 + 0.2, d2 = stud_head_d + 0.2, h = stud_head_h + 0.01);
        if (tip_concave > 0) translate([0, 0, -0.01]) cylinder(d1 = tip_d - 3, d2 = 0, h = tip_concave);
    }
}

// ============================================================================
// --- 7. MODELE REFERENCYJNE (kupne, nie do druku) ---------------------------
// ============================================================================
module ArmTubeRef() translate([tube_end_x, 0, z_arm]) rotate([0, 90, 0])
    difference() { cylinder(d = arm_tube_od, h = arm_tube_len); translate([0, 0, -1]) cylinder(d = arm_tube_id, h = arm_tube_len + 2); }
module ArmTubesRef() for (s = [-1, 1]) MirrorX(s) ArmTubeRef();

module RefVials() color(c_ref) {
    translate([0, 0, Z_top - top_vial_depth + 3.5 * spacing])
        difference() { cylinder(d = top_vial_od, h = top_vial_depth + 40); translate([0, 0, -1]) cylinder(d = top_vial_od - 2.4, h = top_vial_depth + 42); }
    translate([0, bore_d / 2 + mesh_t + spacing, Z1 + spacing + tc_h / 2]) rotate([-90, 0, 0])
        cylinder(d = train_odor_vial_od, h = train_odor_vial_depth + 20);
    for (s = [-1, 1]) MirrorX(s) {
        translate([0.5 * spacing, 0, 0]) ArmTubeRef();
        translate([arm_x0 + arm_l2 + 2.5 * spacing, 0, z_arm]) rotate([0, 90, 0]) cylinder(d = arm_odor_vial_od, h = arm_odor_vial_depth + 20);
    }
}

// ============================================================================
// --- 7.5. SYSTEM STOPEK I PODPOR --------------------------------------------
// ============================================================================

module FeetDovetailProfile(tol=0, base_y=0) {
    polygon([
        [-(feet_dt_w_base/2 + tol), base_y],
        [(feet_dt_w_base/2 + tol), base_y],
        [(feet_dt_w_top/2 + tol), feet_dt_h + tol],
        [-(feet_dt_w_top/2 + tol), feet_dt_h + tol]
    ]);
}

// Rowki stopek pod korpusem T: jak w stosie - otwarte od -Y, zabudowane dt_stop od +Y (ogranicznik wsuwu)
module FeetDovetailGrooves() {
    for (sx = [-1, 1]) {
        translate([sx * feet_dt_offset, frame_w/2 - dt_stop, 0])
        rotate([90, 0, 0])
        linear_extrude(frame_w)
        FeetDovetailProfile(feet_dt_tol, -0.01);
    }
}

module MainFoot() {
    dx = (feet_len_y - frame_w) / 2;
    angled_h = dx / tan(feet_angle);
    straight_h = max(0, feet_h - angled_h);
    
    // Zlacze dovetail (meskie): skrocone o dt_stop od +Y, zeby trafic w ogranicznik rowka
    translate([0, frame_w/2 - dt_stop, 0])
    rotate([90, 0, 0])
    linear_extrude(frame_w - dt_stop)
    FeetDovetailProfile(0, 0);
    
    // Korpus stopki - zamieniono sposob definiowania tak, aby orientacja 3D
    // byla bezwzglednie poprawna (grubosc po osi X, dlugosc po osi Y, opadanie do -feet_h)
    rotate([0, 90, 0]) linear_extrude(feet_thick, center=true)
    polygon([
        [0, -frame_w/2],
        [0, frame_w/2],
        [straight_h, frame_w/2],
        [feet_h, feet_len_y/2],
        [feet_h, -feet_len_y/2],
        [straight_h, -frame_w/2]
    ]);
}

// Podpora zielonej tuby: lozysko o profilu identycznym z modulem ramienia w miejscu
// support_pos_x (ArmProfile2D, z kilem), powiekszonym o support_arm_t; pin od spodu.
module ArmSupport() {
    r_mod = arm_R_at(support_pos_x);
    t_sup = support_arm_t > 0 ? support_arm_t : op_wall;
    R_out = r_mod + t_sup;
    union() {
        difference() {
            hull() {
                translate([0, 0, z_arm]) rotate([0, 90, 0])
                    linear_extrude(support_arm_w, center=true) offset(r = t_sup) ArmProfile2D(support_pos_x);
                // Dolna podstawa na rowni z głównymi stopkami
                translate([0, 0, -feet_h])
                    cube([support_arm_w, 2*R_out + 10, 0.02], center=true);
            }
            // Wyciecie na zielona tube (ten sam profil co modul: okrag + kil)
            translate([0, 0, z_arm]) rotate([0, 90, 0])
                linear_extrude(support_arm_w + 2, center=true) ArmProfile2D(support_pos_x);
            // Odciecie gornej czesci (zostawiamy 2 mm powyzej srodka, zeby obejmowalo tube na wcisk)
            translate([0, 0, z_arm + R_out + 2.0])
                cube([support_arm_w + 2, 2*R_out + 2, 2*R_out], center=true);
        }
        // Pin centrujacy (idący pionowo w górę od styku ze stopka modulu)
        translate([0, 0, z_arm - arm_mod_R - 0.01]) cylinder(d = support_pin_d, h = support_pin_h + 0.01, $fn=32);
    }
}

// ============================================================================
// --- 8. ZLOZENIE ------------------------------------------------------------
// ============================================================================
z_tip = z_stop + (1 - plunger_pos) * (Z_top - z_stop);   // czolo koncowki w swiecie

module MainStack() { TBody(); translate([0, 0, Z1]) TrainChamber(); translate([0, 0, Z2]) TopAdapter(); }

module FullAssembly() {
    color(c_body) TBody();
    color(c_body) translate([0, 0, Z1 + spacing]) TrainChamber();
    color(c_body) translate([0, 0, Z2 + 2 * spacing]) TopAdapter();
    color(c_sliders) translate([0, -spacing, 0]) GatePlaced(Z1, gates_open[1]);          // G2: kieszen w wierzchu korpusu T
    color(c_sliders) translate([0, -spacing, spacing]) GatePlaced(Z2, gates_open[0]);    // G1: kieszen w wierzchu komory treningowej
    for (s = [-1, 1]) color(c_sliders) translate([0, 0, 0.7 * spacing])
        GuillotinePlaced(s, s < 0 ? gates_open[2] : gates_open[3]);
    for (s = [-1, 1]) MirrorX(s) {
        color(c_odor) translate([1.5 * spacing, 0, 0]) ArmModulePlaced();
        color(c_body) translate([feet_dt_offset, 0, -spacing]) MainFoot();
        color(c_body) translate([arm_x0 + support_pos_x, 0, 0]) ArmSupport();
    }
    color(c_plunger) translate([0, 0, z_tip + 2.5 * spacing]) Plunger();
    color(c_tpu) translate([0, 0, z_tip + 2.0 * spacing]) TPUTip();
    // zatyczka-prowadnica: w gniezdzie kolby, gdy nie pokazujemy kolby; inaczej obok
    if (show_vials) { translate([frame_w / 2 + 28, 0, Z_top + 2 * spacing]) color(c_body) PlungerGuide(); RefVials(); }
    else color(c_body) translate([0, 0, Z_top + 3 * spacing]) PlungerGuide();
}

// Tryb diagnostyczny: czerwone bryly = przenikanie par, ktore nie powinny sie przenikac
module CollisionCheck() color([1, 0, 0]) {
    for (o = [true, false]) {
        intersection() { GatePlaced(Z1, o); MainStack(); }
        intersection() { GatePlaced(Z2, o); MainStack(); }
        for (s = [-1, 1]) intersection() {
            GuillotinePlaced(s, o);
            union() { MainStack(); ArmTubesRef(); for (t = [-1, 1]) MirrorX(t) ArmModulePlaced(); }
        }
    }
    intersection() { translate([0, 0, z_stop]) union() { Plunger(); TPUTip(); } MainStack(); }
    for (s = [-1, 1]) intersection() { MirrorX(s) ArmModulePlaced(); union() { MainStack(); } }
    intersection() { ArmTubesRef(); for (s = [-1, 1]) MirrorX(s) ArmModulePlaced(); }

}

module PrintLayout() {
    // Rozklad czesci na plaskim stole z duzymi odstepami (bezpieczne do slicera)
    
    // Rząd 1: Główne korpusy i adapter (os Y = 0)
    translate([0, 0, 0]) TBody();
    translate([100, 0, 0]) TrainChamber();
    translate([180, 0, 0]) TopAdapter();
    translate([260, 0, cap_flange_t]) rotate([180, 0, 0]) PlungerGuide(true);
    
    // Rząd 2: Płaskie zasuwki, gilotyny, tłok i koncowka (os Y = 100)
    translate([0, 100, 0]) Gate();
    translate([50, 100, 0]) Gate();
    translate([100, 100, 0]) ArmGuillotine();
    translate([150, 100, 0]) ArmGuillotine();
    translate([210, 100, plunger_len]) rotate([180, 0, 0]) Plunger();
    translate([260, 100, 0]) TPUTip();
    
    // Rząd 3: Moduły boczne zielone i wszystkie korki (os Y = 200)
    // Zachowana oryginalna rotacja drukarska z selektora czesci
    translate([0, 200, 0]) translate([-arm_x0, 0, arm_mod_R - z_arm]) ArmModulePlaced();
    translate([80, 200, 0]) translate([-arm_x0, 0, arm_mod_R - z_arm]) ArmModulePlaced();
    
    // Rząd 4: Stopki i podpory (os Y = -100)
    translate([0, -100, feet_h]) MainFoot();
    translate([30, -100, feet_h]) MainFoot();
    translate([100, -100, support_arm_w/2]) rotate([0, 90, 0]) ArmSupport();
    translate([180, -100, support_arm_w/2]) rotate([0, 90, 0]) ArmSupport();
}

// ============================================================================
// --- 9. SELEKTOR CZESCI (kazda czesc w orientacji do druku, na Z=0) ----------
// ============================================================================
if (part == "assembly") { FullAssembly(); if (show_collisions) CollisionCheck(); }
else if (part == "print_all")         PrintLayout();
else if (part == "top_adapter")       TopAdapter();
else if (part == "plunger_guide_cap") translate([0, 0, cap_flange_t]) rotate([180, 0, 0]) PlungerGuide(true);
else if (part == "training_chamber")  TrainChamber();
else if (part == "t_body")            TBody();
else if (part == "arm_odor_module")   translate([-arm_x0, 0, arm_mod_R - z_arm]) ArmModulePlaced();
else if (part == "gate")              Gate();
else if (part == "guillotine")        ArmGuillotine();
else if (part == "plunger")           translate([0, 0, plunger_len]) rotate([180, 0, 0]) Plunger();
else if (part == "plunger_tip_tpu")   TPUTip();
else if (part == "main_foot")         translate([0, 0, feet_h]) MainFoot();
else if (part == "support")           translate([0, 0, support_arm_w/2]) rotate([0, 90, 0]) ArmSupport();
else assert(false, str("Nieznana nazwa czesci: ", part));

// ============================================================================
// --- 10. SPRAWDZENIA I WYMIARY WYNIKOWE -------------------------------------
// ============================================================================
assert(slot_h > gate_t && slot_w > gate_w, "Kieszen zasuwki nie jest wieksza od plytki");
assert(norm([rib_span, rib_w]) + 2 <= bore_d, "Obrys trzonu tloka za duzy wzgledem kanalu");
assert(tip_d < bore_d && tip_clearance <= 0.6, "Luz koncowki TPU poza zakresem (mucha lub tarcie)");
assert(guil_x - guil_slot_w / 2 >= frame_w / 2 + 1, "Gilotyna koliduje z obrysem komory treningowej");
assert(guil_x + guil_slot_w / 2 + wall <= tube_end_x + 0.001, "Szczelina gilotyny koliduje z gniazdem rurki ramienia");
assert(z_stop - cap_flange_t >= z_arm + arm_tube_id / 2, "Tlok na ograniczniku siega wylotow rurek");
assert(rod_len > marker_2 && marker_1 > 0, "Trzon tloka za krotki na znaczniki");
assert(top_sock_d >= bore_d, "Kolba wezsza od kanalu: lejek 45 st. niemozliwy");
// assert(m3_off - m3_d / 2 >= slot_w / 2 + 1.2, "Otwory M3 przecinaja kieszen zasuwki");
// assert(pin_off - pin_d / 2 - press_tol >= slot_w / 2 + 1.0, "Czopy centrujace przecinaja kieszen zasuwki");
assert(mesh_hole_d <= 1.0, "Otwory sitek za duze dla muchy");
assert(mesh_bridge >= 0.8, "Mostki sitka za cienkie");
assert(gate_hc - bore_d / 2 >= 2 && gate_len - gate_hc - gate_travel - bore_d / 2 >= 2, "Zakladka zasuwki < 2 mm");
assert(guil_base_z >= 2, "Szczelina gilotyny przebija dno korpusu T");
assert(drain_d >= 10, "Spust za waski dla uspionych much");
// v3.1: spojnosc powlok przezroczystych
assert(tp_wall > 0 && op_wall > 0, "Grubosc scianki musi byc > 0");
if (tp_wall < 1.2) echo("UWAGA: tp_wall < 1.2 mm - scianki przezroczyste moga byc nieszczelne/za slabe");
if (op_wall < 1.2) echo("UWAGA: op_wall < 1.2 mm - scianka miedzy gilotyna a gniazdem rurki bardzo cienka");
assert(tb_tower_hw + guil_x <= tube_end_x + 0.001, "Wieza gilotyny wchodzi w gniazdo rurki (tp_wall > wall)");
assert(tb_shell_R <= frame_w / 2 && tb_boss_R <= frame_w / 2, "Powloka korpusu T szersza od kolnierza 44 mm");
assert(tc_fl_top + tc_skirt_h + tc_fl_bot <= tc_h, "Spodnica plyty gornej komory siega kolnierza dolnego (zmniejsz ovh_angle lub tp_wall)");
assert(tc_tube_od / 2 + tc_vent_boss_len < frame_w / 2, "Boss wylotu plukania wystaje poza obrys 44 mm");
assert(arm_foot_w(arm_R_B) <= arm_R_B, "Stopka sekcji fiolki szersza od jej srednicy");
assert(support_pin_h + support_pin_bottom_gap + 1.0 <= arm_mod_R - arm_vial_d / 2, "Slot pinu podpory przebija gniazdo fiolki (za wysoki pin)");
assert(support_pin_d + 2 * support_pin_tol <= 2 * arm_foot_w(arm_R_B) - 1, "Slot pinu szerszy od stopki modulu ramienia");
assert(support_pos_x + support_arm_w / 2 <= arm_l3 && support_pos_x - support_arm_w / 2 >= arm_step, "Podpora ramienia wystaje poza sekcje gniazda fiolki (uskok srednicy w arm_step)");

echo(str("v3.0 | tlok z koncowka TPU: ", plunger_len, " mm (trzon ", rod_len, " mm)"));
echo(str("Wysokosc stosu (korpus T + komora + adapter): ", stack_h, " mm; korpus T: ", 2 * tbody_hx, " x ", frame_w, " x ", tb_h, " mm"));
echo("Połączenie modułów: bezśrubowe, mechanizm wsuwany dovetail z zatrzaskiem");
echo(str("Zasuwka: plytka ", gate_w, " x ", gate_len, " x ", gate_t, " mm, kieszen ", slot_w, " x ", slot_h, " mm, skok ", gate_travel, " mm"));
echo(str("Gilotyna: os x=+-", guil_x, ", koniec rurki x=+-", tube_end_x, ", podniesienie ", guil_lift, " mm"));
echo(str("Karby tloka od spodu kolnierza: nad G2 = ", marker_1, " mm, nad G1 = ", marker_2, " mm"));
echo(str("Rozpietosc ramion (do zewn. czol modulow zielonych): ", 2 * (arm_x0 + arm_l3), " mm"));
echo(str("v3.1 przezroczyste: scianka ", tp_wall, " mm | korpus T: powloka R", tb_shell_R, ", mufa R", tb_boss_R, ", pas podstawy ", 2 * tb_base_hw, " mm | komora: rura D", tc_tube_od, ", spodnica ", tc_skirt_h, " mm | modul ramienia: R", arm_R_A, "/", arm_R_B, ", stopka ", 2 * arm_foot_w(arm_R_A), "/", 2 * arm_foot_w(arm_R_B), " mm"));
