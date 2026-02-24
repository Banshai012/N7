open Rat
open Compilateur
open Passe

(* Return la liste des adresses des variables d'un programme RAT *)
let getListeDep ratfile =
  let input = open_in ratfile in
  let filebuf = Lexing.from_channel input in
  try
    let ast = Parser.main Lexer.token filebuf in
    let past = CompilateurRat.calculer_placement ast in
    let listeAdresses = VerifPlacement.analyser past in
    listeAdresses
  with
  | Lexer.Error _ as e ->
      report_error ratfile filebuf "lexical error (unexpected character).";
      raise e
  | Parser.Error as e->
      report_error ratfile filebuf "syntax error.";
      raise e

(* teste si dans le fichier fichier, dans la fonction fonction (main pour programme principal)
la occ occurence de la variable var a l'adresse dep[registre]
*)
let test fichier fonction (var,occ) (dep,registre) = 
  let l = getListeDep fichier in
  let lmain = List.assoc fonction l in
  let rec aux i lmain = 
    if i=1 
    then
      let (d,r) = List.assoc var lmain in
      (d=dep && r=registre)
    else 
      aux (i-1) (List.remove_assoc var lmain)
  in aux occ lmain

(****************************************)
(** Chemin d'accès aux fichiers de test *)
(****************************************)

let pathFichiersRat = "../../../../../tests/placement/avec_fonction/fichiersRat/"


let%test "test8_x_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x",1)  (0, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x",1)  (0, "LB")
    
let%test "test8_y_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y",1)  (1, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y",1)  (1, "LB")
    
let%test "test8_z_1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("z",1)  (3, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("z",1)  (3, "LB")
  
let%test "test8_x_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x",2)  (4, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x",2)  (4, "LB")
    
let%test "test8_y_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y",2)  (5, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y",2)  (5, "LB")
    
let%test "test8_z_2" = 
   test (pathFichiersRat^"test8.rat")  "main" ("z",2)  (7, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("z",2)  (7, "LB")
  
let%test "test8_x1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("x1",1)  (4, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("x1",1)  (4, "LB")
    
let%test "test8_y1" = 
   test (pathFichiersRat^"test8.rat")  "main" ("y1",1)  (5, "SB")
|| test (pathFichiersRat^"test8.rat")  "main" ("y1",1)  (5, "LB")
    
let%test "test8_z1" = 
   test (pathFichiersRat^"test8.rat" ) "main" ("z1",1)  (7, "SB")
|| test (pathFichiersRat^"test8.rat" ) "main" ("z1",1)  (7, "LB")

let%test "test13_x" = 
   test (pathFichiersRat^"test13.rat" ) "main" ("x",1)  (0, "SB")

let%test "test13_y" = 
   test (pathFichiersRat^"test13.rat" ) "main" ("y",1)  (1, "SB")

let%test "test13_z" = 
   test (pathFichiersRat^"test13.rat" ) "main" ("z",1)  (2, "SB")

let%test "test8_f_x_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x",1)  (3, "LB")
    
let%test "test8_f_y_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y",1)  (4, "LB")
    
let%test "test8_f_z_1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z",1)  (6, "LB")
  
let%test "test8_f_x_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x",2)  (7, "LB")
    
let%test "test8_f_y_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y",2)  (8, "LB")
    
let%test "test8_f_z_2" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z",2)  (10, "LB")
  
let%test "test8_f_x1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("x1",1)  (7, "LB")
    
let%test "test8_f_y1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("y1",1)  (8, "LB")
    
let%test "test8_f_z1" = 
  test (pathFichiersRat^"test8.rat")  "f" ("z1",1)  (10, "LB")
    
let%test "test8_f_a" = 
  test (pathFichiersRat^"test8.rat")  "f" ("a",1)  (-1, "LB")
    
let%test "test9_f_a" = 
  test (pathFichiersRat^"test9.rat")  "f" ("a",1)  (-1, "LB")

let%test "test10_f_a" = 
  test (pathFichiersRat^"test10.rat")  "f" ("a",1)  (-2, "LB")

let%test "test11_f_a" = 
  test (pathFichiersRat^"test11.rat")  "f" ("a",1)  (-1, "LB")
    
let%test "test12_f_b" = 
  test (pathFichiersRat^"test12.rat")  "f" ("b",1)  (-4, "LB")
    
let%test "test12_f_r" = 
  test (pathFichiersRat^"test12.rat")  "f" ("r",1)  (-3, "LB")
    
let%test "test12_f_i" = 
  test (pathFichiersRat^"test12.rat")  "f" ("i",1)  (-1, "LB")

let%test "test13_f_a" = 
  test (pathFichiersRat^"test13.rat")  "f" ("a",1)  (-4, "LB")

let%test "test13_f_b" = 
  test (pathFichiersRat^"test13.rat")  "f" ("b",1)  (-3, "LB")

let%test "test13_f_c" = 
  test (pathFichiersRat^"test13.rat")  "f" ("c",1)  (-2, "LB")

let%test "testProcedure1_x" = 
  test (pathFichiersRat^"testProcedure1.rat")  "main" ("x",1)  (0, "SB")
  
let%test "testProcedure1_y" = 
  test (pathFichiersRat^"testProcedure1.rat")  "main" ("y",1)  (2, "SB")

let%test "testProcedure1_f_a" = 
  test (pathFichiersRat^"testProcedure1.rat")  "f" ("a",1)  (-4, "LB")

let%test "testProcedure1_f_b" = 
  test (pathFichiersRat^"testProcedure1.rat")  "f" ("b",1)  (-2, "LB")

let%test "testProcedure2_param_b" = 
  test (pathFichiersRat^"testProcedure2.rat") "maProcedure" ("b",1) (-1, "LB")

let%test "testProcedure2_local" = 
  test (pathFichiersRat^"testProcedure2.rat") "maProcedure" ("local",1) (3, "LB")

let%test "testProcedure3_r" = 
  test (pathFichiersRat^"testProcedure3.rat") "printInfo" ("r",1) (-2, "LB")

let%test "testProcedure3_id" = 
  test (pathFichiersRat^"testProcedure3.rat") "printInfo" ("id",1) (-3, "LB")

let%test "testEnum1" = 
  test (pathFichiersRat^"testEnum1.rat") "estDateRenduProjet" ("j",1)  (-4, "LB")

let%test "testEnum3_s" = 
  test (pathFichiersRat^"testEnum3.rat") "checkStatus" ("s",1) (-1, "LB")

let%test "testEnum3_check" = 
  try 
    let _ = getListeDep (pathFichiersRat^"testEnum3.rat") in true
  with _ -> false

let%test "testRef1_p_b" = 
  test (pathFichiersRat^"testRef1.rat") "p" ("b",1) (-1, "LB")

let%test "testRef1_p_a" = 
  test (pathFichiersRat^"testRef1.rat") "p" ("a",1) (-2, "LB")

let%test "testRef1_main_x" = 
  test (pathFichiersRat^"testRef1.rat") "main" ("x",1) (0, "SB")

let%test "testRef1_main_r" = 
  test (pathFichiersRat^"testRef1.rat") "main" ("r",1) (1, "SB")

let%test "testRef2_y" = 
  test (pathFichiersRat^"testRef2.rat") "testRef" ("y",1) (-1, "LB")

let%test "testRef2_x" = 
  test (pathFichiersRat^"testRef2.rat") "testRef" ("x",1) (-2, "LB")

let%test "testRef3_r" = 
  test (pathFichiersRat^"testRef3.rat") "doubleRat" ("r",1) (-1, "LB")

let%test "testRef3_x" = 
  test (pathFichiersRat^"testRef3.rat") "main" ("x",1) (0, "SB")

let%test "testUltime1_echanger_y" =
  test (pathFichiersRat^"testUltime1.rat") "echanger" ("y",1) (-1, "LB")

let%test "testUltime1_echanger_x" =
  test (pathFichiersRat^"testUltime1.rat") "echanger" ("x",1) (-2, "LB")

let%test "testUltime1_echanger_tmp" =
  test (pathFichiersRat^"testUltime1.rat") "echanger" ("tmp",1) (3, "LB")

let%test "testUltime1_appliquerOperation_y" =
  test (pathFichiersRat^"testUltime1.rat") "appliquerOperation" ("y",1) (-1, "LB")

let%test "testUltime1_appliquerOperation_x" =
  test (pathFichiersRat^"testUltime1.rat") "appliquerOperation" ("x",1) (-2, "LB")

let%test "testUltime1_appliquerOperation_op" =
  test (pathFichiersRat^"testUltime1.rat") "appliquerOperation" ("op",1) (-3, "LB")

let%test "testUltime1_afficherValeurPointee_p" =
  test (pathFichiersRat^"testUltime1.rat") "afficherValeurPointee" ("p",1) (-1, "LB")

let%test "testUltime1_intialiserPointeur_v" =
  test (pathFichiersRat^"testUltime1.rat") "intialiserPointeur" ("v",1) (-1, "LB")

let%test "testUltime1_intialiserPointeur_p" =
  test (pathFichiersRat^"testUltime1.rat") "intialiserPointeur" ("p",1) (3, "LB")

let%test "testUltime1_main_a" =
  test (pathFichiersRat^"testUltime1.rat") "main" ("a",1) (0, "SB")

let%test "testUltime1_main_b" =
  test (pathFichiersRat^"testUltime1.rat") "main" ("b",1) (1, "SB")

let%test "testUltime1_main_p1" =
  test (pathFichiersRat^"testUltime1.rat") "main" ("p1",1) (2, "SB")

let%test "testUltime1_main_p2" =
  test (pathFichiersRat^"testUltime1.rat") "main" ("p2",1) (3, "SB")

let%test "testUltime1_main_p3" =
  test (pathFichiersRat^"testUltime1.rat") "main" ("p3",1) (4, "SB")