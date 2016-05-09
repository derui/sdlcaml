[%%suite
 open Sdlcaml.Std
 module S = Structures

 let%spec "The SDL Rect module should be able to calculate a minimal rectangle enclosing a set of points" =
   let open Rect in
   let module R = S.Rect in
   let module P = S.Point in
   let points = [{P.x = 1;y = 2}; {P.x = -1; y = -2}] in
   (enclose_points ~points ()) [@eq {R.w = 2;h = 4; x = -1; y = -2}];
   (enclose_points ~points ()) [@ne {R.w = 0;h = 0; x = 0; y = 0}]

 let%spec "The SDL Rect module should be able to calculate a minimal rectangle with clip rect" =
   let open Rect in
   let module R = S.Rect in
   let module P = S.Point in
   let clip = {R.x = 0; y = 0; w = 2; h = 2} in
   let points = [{P.x = 1;y = 2}; {P.x = -1; y = -2}] in
   (enclose_points ~points ~clip ()) [@eq {R.w = 1;h = 2; x = 0; y = 0}]

 let%spec "The SDL Rect module should return empty rectangle if no any points enclosed in rectangle as clip" =
   let open Rect in
   let module R = S.Rect in
   let module P = S.Point in
   let clip = {R.x = 0; y = 0; w = 2; h = 2} in
   let points = [{P.x = -1;y = 2}; {P.x = 1; y = -2}] in
   (enclose_points ~points ~clip ()) [@eq {R.w = 0;h = 0; x = 0; y = 0}]

 let%spec "The SDL Rect module can check the rectangle is empty or not" =
   let open Rect in
   let module R = S.Rect in
   (is_empty {R.x = 100; y = 100; h = 0; w = 0}) [@eq true];
   (is_empty {R.x = 100; y = 100; h = 1; w = 0}) [@eq false];
   (is_empty {R.x = 100; y = 100; h = 0; w = 1}) [@eq false];
   (is_empty {R.x = 100; y = 100; h = 1; w = 1}) [@eq false]

 let%spec "The SDL Rect module should detect intersection between two rectangles" =
   let open Rect in
   let module R = S.Rect in
   let a = {R.x = 0; y = 0; w = 2; h = 2}
   and b = {R.x = 2; y = 2; w = 1; h = 1} in
   (has_intersection a b) [@eq false];
   (has_intersection b a) [@eq false];
   let c = {R.x = 1; y = 1; w = 1; h = 1} in
   (has_intersection a c) [@eq true];
   (has_intersection c a) [@eq true]

 let%spec "The SDL Rect module should return rectangle that is intersected between two rectangles" =
   let open Rect in
   let module R = S.Rect in
   let a = {R.x = 0; y = 0; w = 2; h = 2}
   and b = {R.x = 1; y = 1; w = 2; h = 2} in
   (intersect a b) [@eq {R.x = 1;y = 1; w = 1; h = 1}];
   (intersect b a) [@eq {R.x = 1;y = 1; w = 1; h = 1}]

 let%spec "The SDL Rect module can check what equals two rectangle" =
   let open Rect in
   let module R = S.Rect in
   let a = {R.x = 1;y = 1;w = 1; h = 1}
   and b = {R.x = 1;y = 1;w = 2; h = 2} in
   (equals a a) [@eq true];
   (equals b b) [@eq true];
   (equals a b) [@eq false];
   (equals b a) [@eq false]

 let%spec "The SDL Rect module should return rectangle what united two rectangle" =
   let open Rect in
   let module R = S.Rect in
   let a = {R.x = 1; y = 1; w = 3; h = 2}
   and b = {R.x = 3; y = 1; w = 2; h = 4} in
   (union a b) [@eq {R.x = 1; y = 1; w = 4; h = 4}];
   (union b a) [@eq {R.x = 1; y = 1; w = 4; h = 4}]
]
