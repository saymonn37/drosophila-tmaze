// ============================================================================
// PROJEKT: Aparat do warunkowania wechowego + labirynt T dla Drosophila (v3.0)
// TECHNOLOGIA: Druk 3D FDM, dysza 0.4 mm. Bez bibliotek zewnetrznych.
//              Zgodne z OpenSCAD 2021.01+.
// ============================================================================
// LISTA CZESCI DO DRUKU (part = "...")        ilosc  material   orientacja
//  "top_adapter"      TopAdapter            1x    PLA/PETG   podstawa (kolnierz) na stole
//  "plunger_guide_cap" PlungerGuide          1x    PLA        kolnierzem do stolu (opcjonalna)
//  "training_chamber" TrainChamber           1x    PLA/PETG   podstawa na stole
//  "t_body"           TBody             1x    PLA/PETG   podstawa na stole
//  "arm_odor_module"  ArmModule             2x    PLA/PETG   lezac na plaskiej stopce krocca spustowego
//  "gate"             Gate (G1, G2)             2x    PLA        na plasko
//  "guillotine"       ArmGuillotine             2x    PLA        na plasko
//  "plug_center"      Plug(center)    1x    PLA        kolnierzem do stolu
//  "plug_arm"         Plug(arm)       2x    PLA        kolnierzem do stolu
//  "plunger"          Plunger                   1x    PLA/PETG   pionowo, glowka (kolnierz) na stole
//  "plunger_tip_tpu"  TPUTip                1x    TPU 95A    czolem do stolu
//  Elementy kupne: 4x pret gwintowany M3 (dl. = stack_h + ~8 mm, patrz echo)
//  lub 4x sruba M3 tej dlugosci, 8x nakretka M3, drut Cu, fiolki/rurki (ZMIERZ).
// ============================================================================

/* [Widok i Eksport] */
// Wybierz część do wyrenderowania
part = "print_all"; // ["assembly":Złożenie 3D, "print_all":Wszystkie części obok siebie, "top_adapter":Adapter górny, "plunger_guide_cap":Zatyczka prowadnica, "training_chamber":Komora treningowa, "t_body":Korpus T, "arm_odor_module":Moduł zielony (na rurkę), "gate":Zasuwka pomarańczowa, "guillotine":Gilotyna, "plug_center":Korek środkowy, "plug_arm":Korek spustowy boczny, "plunger":Tłok strzykawki, "plunger_tip_tpu":Końcówka TPU]
// Pokaz widok rozstrzelony (rozsuniete czesci)
exploded_view = false; 

/* [Ustawienia Siatki] */
// Rozdzielczość (gładkość okręgów)
$fn = 128; // [16:16:1024]

/* [Wymiary Główne i Otwory] */
// Srednica kanalu pionowego (glowny tunel na strzykawke)
bore_d = 20.0; // [10:0.1:40]
// Srednica zewnetrzna rurek bocznych (przezroczystych)
arm_tube_od = 20.0; // [10:0.1:40]
// Srednica wewnetrzna rurek bocznych
arm_tube_id = 16.0; // [5:0.1:30]
// Srednica otworow wywietrznikowych
vent_d = 6.0; // [2:0.1:20]
// Srednica fiolki zapachowej (os Y, srodek)
train_odor_vial_od = 14.0; // [5:0.1:30]

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

/* [Hidden] */
gates_open      = [true, true, true, true]; // [G1, G2, gilotyna lewa, gilotyna prawa]
plunger_pos     = 0.0;        // 0 = tlok wyjety do gory, 1 = tlok na ograniczniku
show_vials      = true;       // polprzezroczyste modele kupnych fiolek i rurek
show_collisions = false;      // tryb diagnostyczny: rysuje przeciecia par czesci
inspection_windows = false;   // okienka podgladowe (cienka scianka + wpust na folie PET)
flush_vent      = true;       // otwor wylotowy do wyplukania zapachu z komory treningowej
spacing = exploded_view ? 30 : 0;

top_vial_od    = 30.0;         // ZMIERZ przed drukiem: kolba z muchami, srednica zewn. szyjki
top_vial_depth = 20.0;         // ZMIERZ przed drukiem: glebokosc osadzenia kolby
train_odor_vial_depth = 16.0;  // ZMIERZ przed drukiem
arm_tube_len  = 80.0;          // ZMIERZ przed drukiem: dlugosc rurki
arm_tube_depth = 10.0;         // glebokosc osadzenia rurki w gniazdach (korpus T i modul zielony)
arm_odor_vial_od    = 14.0;    // ZMIERZ przed drukiem: fiolka zapachowa na koncu ramienia
arm_odor_vial_depth = 16.0;    // ZMIERZ przed drukiem

fit_tol   = 0.3;   // pasowanie suwliwe (zasuwki, gilotyny, fiolki, rurki)
press_tol = 0.2;   // pasowanie wciskane (korki, czopy centrujace)
gate_t    = 2.4;   // grubosc plytek zasuwek i gilotyn (12 warstw po 0.2)
tip_clearance = 0.4; // luz srednicowy koncowki TPU w kanale
mesh_hole_d = 1.0; // otwory sitek (mucha nie przejdzie)
mesh_bridge = 0.9; // mostek miedzy otworami sitka (>= 2 szerokosci linii)
mesh_t      = 1.6; // grubosc scianki sitka
wall  = 2.0;       // minimalna grubosc scianki
frame_w  = 44.0;   // bok kwadratowego kolnierza stosu
tc_h     = 50.0;   // wysokosc komory treningowej
plug_center_len = 12.0; // dlugosc trzpienia korka srodkowego = wysokosc dna komory startowej
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
z_floor = plug_center_len;                   // dno komory = wierzch korka srodkowego
z_arm   = z_floor + arm_tube_id / 2;         // os rurek ramion (dol wylotu = dno komory)
cap_flange_t = 3.0;                          // grubosc kolnierza zatyczki-prowadnicy tloka
z_stop  = z_arm + arm_tube_id / 2 + cap_flange_t; // strop komory startowej = dolna pozycja tloka
tb_h    = z_stop + slot_h + 3;               // wysokosc korpusu T (kieszen G2 w jego wierzchu)
guil_slot_w  = gate_t + 2 * fit_tol;              // szczelina gilotyny (grubosc)
guil_x     = frame_w / 2 + 2 + guil_slot_w / 2;      // os gilotyny: poza obrysem komory treningowej
tube_end_x    = guil_x + guil_slot_w / 2 + wall;           // koniec wsunietej rurki ramienia
tbody_hx = tube_end_x + arm_tube_depth;           // polowa szerokosci korpusu T (os X)
guil_w  = arm_tube_id + 4;                   // plytka gilotyny: 2 mm zakladki
guil_base_z    = z_arm - arm_tube_id / 2 - 2;       // dno szczeliny gilotyny
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
arm_mod_R   = max(arm_sock_d, arm_vial_d) / 2 + teardrop_cap + wall;
arm_fly_len = drain_d + 4;                   // komora much nad spustem
arm_l0 = arm_tube_depth; arm_l1 = arm_l0 + arm_fly_len; arm_l2 = arm_l1 + mesh_t;
arm_l3 = arm_l2 + arm_odor_vial_depth;         // dlugosc modulu
drain_ext   = 4.0;
drain_boss_w = max(drain_d + 2 * wall, 1.5 * arm_mod_R); // stopka >= 1.42 R: nawis korpusu < 45 st.
plug_arm_len = arm_mod_R + drain_ext - arm_tube_id / 2;
arm_x0 = tube_end_x + arm_tube_len - arm_tube_depth; // wewnetrzne czolo modulu zielonego
x_drain = arm_x0 + arm_l0 + arm_fly_len / 2;    // os spustu ramienia
// Komora treningowa
train_sock_d = train_odor_vial_od + 2 * fit_tol;
odor_boss_len = max(0, bore_d / 2 + mesh_t + train_odor_vial_depth + 1 - frame_w / 2);

// Kolory (jak w v2.0)
c_body    = [0.20, 0.22, 0.25, 1.0];  // grafit: korpus, komory
c_sliders = [0.90, 0.40, 0.15, 1.0];  // pomaranczowy: zasuwki, gilotyny
c_odor    = [0.20, 0.70, 0.40, 0.90]; // zielony: moduly zapachowe
c_plugs   = [0.80, 0.20, 0.25, 1.0];  // czerwony: korki
c_plunger = [0.85, 0.85, 0.80, 1.0];  // tlok
c_tpu     = [0.30, 0.30, 0.35, 1.0];  // koncowka TPU
c_ref     = [0.75, 0.88, 0.98, 0.35]; // referencyjne fiolki/rurki

// ============================================================================
// --- 5. POMOCNICZE PRYMITYWY ------------------------------------------------
// ============================================================================
// Siatka otworow sitka (wzdluz lokalnego Z) w kole o promieniu r_area
module MeshHoles(r_area, len) {
    p = mesh_hole_d + mesh_bridge;
    n = floor(r_area / p);
    for (ix = [-n : n], iy = [-n : n])
        if (norm([ix * p, iy * p]) <= r_area - mesh_hole_d / 2)
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
module DovetailGrooves() for (sx = [-1, 1]) translate([sx * dt_offset, frame_w/2 - 2, 0]) rotate([90, 0, 0]) linear_extrude(frame_w) DovetailProfile(dt_tol, -0.01);
module DovetailRails(h) for (sx = [-1, 1]) translate([sx * dt_offset, frame_w/2 - 2, h]) rotate([90, 0, 0]) linear_extrude(frame_w - 2) DovetailProfile(0, 0);
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
// DRUK: podstawa na stole. Nawis bossa gniazda zapachowego sciety 45 st.
// W gornej powierzchni kieszen zasuwki G1 (przykrywa ja adapter).
// ----------------------------------------------------------------------------
module TrainChamber() {
    bw = train_sock_d + 2 * wall;                       // szerokosc bossa
    bh = 2 * (train_sock_d / 2 + teardrop_cap + wall);  // wysokosc bossa
    zc = tc_h / 2;
    difference() {
        union() {
            Block(tc_h);
            DovetailRails(tc_h);
            if (odor_boss_len > 0) hull() {
                translate([-bw / 2, frame_w / 2 - 0.01, zc - bh / 2 - odor_boss_len]) cube([bw, 0.01, bh + odor_boss_len]);
                translate([-bw / 2, frame_w / 2 + odor_boss_len - 0.01, zc - bh / 2]) cube([bw, 0.01, bh]);
            }
        }
        // Kompletnie gladki tunel glowny bez żebrowania na elektrody
        translate([0, 0, -1]) cylinder(d = bore_d, h = tc_h + 2);

        // gniazdo fiolki zapachowej (+Y) i sitko
        translate([0, bore_d / 2 + mesh_t, zc]) rotate([-90, 0, 0]) cylinder(d=train_sock_d, h=frame_w);
        translate([0, bore_d / 2 - 2, zc]) rotate([-90, 0, 0]) MeshHoles(train_odor_vial_od / 2 - 1.5, mesh_t + 4);
        // wylot plukania (-Y), tez z sitkiem
        if (flush_vent) mirror([0, 1, 0]) {
            translate([0, bore_d / 2 + mesh_t, zc]) rotate([-90, 0, 0]) cylinder(d=vent_d, h=frame_w);
            translate([0, bore_d / 2 - 2, zc]) rotate([-90, 0, 0]) MeshHoles(vent_d / 2 - 0.5, mesh_t + 4);
        }
        GatePocket(tc_h);
        DovetailGrooves();
        if (inspection_windows) InspectionWindow(frame_w / 2, 8, tc_h - slot_h - 7);
    }
    GateDetent(tc_h);
}

// ----------------------------------------------------------------------------
// TBody(): korpus labiryntu T z komora startowa (komora 2).
// Lokalnie Z=0..tb_h, X = +-tbody_hx, Y = +-frame_w/2. DRUK: podstawa na stole
// (przeloty poziome w profilu kropli, zadnych podpor).
// Gilotyny leza POZA obrysem komory treningowej (guil_x > frame_w/2), zeby dalo sie
// je podnosic od gory przy zlozonym stosie; szczelina lezy miedzy komora startowa
// a koncem wsunietej rurki (tube_end_x). Kieszen G2 w wierzchu. Dno komory = korek srodkowy.
// ----------------------------------------------------------------------------
module TBody() {
    difference() {
        union() { Block(tb_h, 2 * tbody_hx, frame_w); DovetailRails(tb_h); }
        translate([0, 0, -1]) cylinder(d = bore_d, h = tb_h + 2);     // kanal + komora + gniazdo korka
        for (s = [-1, 1]) MirrorX(s) translate([0, 0, z_arm]) {
            rotate([0, 90, 0]) cylinder(d=arm_tube_id, h=tube_end_x + 0.01);                       // przelot do rurki (idealnie okragly)
            translate([tube_end_x, 0, 0]) rotate([0, 90, 0]) cylinder(d=arm_sock_d, h=tbody_hx); // gniazdo rurki z kolnierzem oporowym (idealnie okragle)
        }
        for (s = [-1, 1]) translate([s * guil_x - guil_slot_w / 2, -(guil_w + 2 * fit_tol) / 2, guil_base_z])
            cube([guil_slot_w, guil_w + 2 * fit_tol, tb_h]);                // szczeliny gilotyn, otwarte od gory
        GatePocket(tb_h);
        if (inspection_windows) rotate([0, 0, 90]) InspectionWindow(frame_w / 2, z_floor + 2, tb_h - slot_h - 3); // w scianie +Y
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
// ----------------------------------------------------------------------------
module ArmModule() {
    difference() {
        union() {
            cylinder(r = arm_mod_R, h = arm_l3);
            translate([(arm_mod_R + drain_ext) / 2, 0, arm_l0 + arm_fly_len / 2])
                cube([arm_mod_R + drain_ext, drain_boss_w, drain_boss_w], center = true);
        }
        translate([0, 0, -1]) cylinder(d=arm_sock_d, h=arm_l0 + 1);          // mufa, kolnierz oporowy na arm_l0
        translate([0, 0, arm_l0 - 0.01]) cylinder(d=arm_tube_id, h=arm_fly_len + 0.02); // komora much
        translate([0, 0, arm_l1 - 1]) MeshHoles(min(arm_tube_id, arm_odor_vial_od) / 2 - 1.5, mesh_t + 2); // sitko
        translate([0, 0, arm_l2]) cylinder(d=arm_vial_d, h=arm_l3);            // gniazdo fiolki zapachowej
        translate([0, 0, arm_l0 + arm_fly_len / 2]) rotate([0, 90, 0]) cylinder(d = drain_d, h = arm_mod_R + drain_ext + 1); // spust
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
            translate([-guil_w / 2, 0, 0]) cube([guil_w, guil_h, gate_t]);
            translate([-(guil_w + 8) / 2, guil_h, 0]) cube([guil_w + 8, 5, gate_t + 2]);
        }
        for (y = [guil_detent_z - guil_base_z, guil_detent_z - guil_base_z - guil_lift])
            translate([guil_w / 2, y, -1]) cylinder(d = 1.2, h = gate_t + 2, $fn = 16);
    }
}
module GuillotinePlaced(side, open)
    translate([side * guil_x - gate_t / 2, 0, guil_base_z + (open ? guil_lift : 0)]) rotate([90, 0, 90]) ArmGuillotine();

// ----------------------------------------------------------------------------
// Plug(): korki spustowe. Lokalnie: kolnierz Z=0..4, trzpien w gore.
// DRUK: kolnierzem do stolu. Wierzch korka srodkowego = plaskie dno komory startowej.
// ----------------------------------------------------------------------------
module Plug(is_center = true) {
    d   = (is_center ? bore_d : drain_d) - 2 * press_tol;
    len = is_center ? plug_center_len : plug_arm_len;
    cylinder(d = d + 8, h = 4);
    translate([0, 0, 3.99]) cylinder(d = d, h = len + 0.01);
}

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
        color(c_plugs) translate([x_drain + 1.5 * spacing, 0, z_arm - arm_mod_R - drain_ext - 4 - spacing]) Plug(false);
    }
    color(c_plugs) translate([0, 0, -4 - spacing]) Plug(true);
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
    intersection() { translate([0, 0, -4]) Plug(true); TBody(); }
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
    translate([0, 200, 0]) translate([-arm_x0, 0, arm_mod_R + drain_ext - z_arm]) ArmModulePlaced();
    translate([80, 200, 0]) translate([-arm_x0, 0, arm_mod_R + drain_ext - z_arm]) ArmModulePlaced();
    translate([150, 200, 0]) Plug(true);
    translate([200, 200, 0]) Plug(false);
    translate([250, 200, 0]) Plug(false);
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
else if (part == "arm_odor_module")   translate([-arm_x0, 0, arm_mod_R + drain_ext - z_arm]) ArmModulePlaced();
else if (part == "gate")              Gate();
else if (part == "guillotine")        ArmGuillotine();
else if (part == "plug_center")       Plug(true);
else if (part == "plug_arm")          Plug(false);
else if (part == "plunger")           translate([0, 0, plunger_len]) rotate([180, 0, 0]) Plunger();
else if (part == "plunger_tip_tpu")   TPUTip();
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

echo(str("v3.0 | tlok z koncowka TPU: ", plunger_len, " mm (trzon ", rod_len, " mm)"));
echo(str("Wysokosc stosu (korpus T + komora + adapter): ", stack_h, " mm; korpus T: ", 2 * tbody_hx, " x ", frame_w, " x ", tb_h, " mm"));
echo("Połączenie modułów: bezśrubowe, mechanizm wsuwany dovetail z zatrzaskiem");
echo(str("Zasuwka: plytka ", gate_w, " x ", gate_len, " x ", gate_t, " mm, kieszen ", slot_w, " x ", slot_h, " mm, skok ", gate_travel, " mm"));
echo(str("Gilotyna: os x=+-", guil_x, ", koniec rurki x=+-", tube_end_x, ", podniesienie ", guil_lift, " mm"));
echo(str("Karby tloka od spodu kolnierza: nad G2 = ", marker_1, " mm, nad G1 = ", marker_2, " mm"));
echo(str("Rozpietosc ramion (do zewn. czol modulow zielonych): ", 2 * (arm_x0 + arm_l3), " mm"));
