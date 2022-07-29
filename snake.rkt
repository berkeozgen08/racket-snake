;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname snake) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct snake [mvm x y tail trailxy applexy])

(define (list-tail l n)
  (remove (car l) l))

(define (tailrepeat s n)
  (cond
    [(= (- (length (snake-trailxy s)) 1) n) (underlay/align/offset "left""top" (square 600 0 "red") (posn-x (list-ref (snake-trailxy s) n))(posn-y (list-ref (snake-trailxy s) n)) (square 30 255 (color 0 0 0 225)))]
    [(>= (length (snake-trailxy s)) 1) (overlay(underlay/align/offset "left""top" (tailrepeat s (+ n 1)) (posn-x (list-ref (snake-trailxy s) n))(posn-y (list-ref (snake-trailxy s) n))(square 30 255 (color 0 0 0 225)))(square 600 0 "red"))]
    [else (circle 1 0 "red")]))

(define (tailpos s n)
  (cond
    [(< (- (length (snake-trailxy s)) 1) n) #false]
    [(<(length (snake-trailxy s)) 3) #false]
    [(boolean=? #false (and (= (snake-x s) (posn-x (list-ref (snake-trailxy s) n)))(= (snake-y s) (posn-y (list-ref (snake-trailxy s) n))))) (tailpos s (+ n 1))]
    [else #true]))

(define (d x)
  (if (string=? (snake-mvm x) "lost")
      (overlay/offset (text (string-append "         You lost\n""         Score: " (number->string (-(snake-tail x)4)) "\nPress enter to reset") 60 "indigo") 0 0 (square 600 0 "red"))
      (overlay (tailrepeat x 0)
               (underlay/align/offset "left" "top"
                                      (underlay/align/offset "left" "top"
                                                             (empty-scene 600 600)
                                                             (posn-x (snake-applexy x))(posn-y (snake-applexy x)) 
                                                             (square 30 255 "red"))
                                      (snake-x x) (snake-y x)
                                      (square 30 255 (color 0 0 0 225))))))

(define (key w x)
  (cond
    [(string=? x "\r") (make-snake "" 300 300 4 '() (make-posn (* 30 (random 20))(* 30 (random 20))))]
    [(string=? x "up") (if (string=? (snake-mvm w) "down") w (make-snake "up" (snake-x w)(snake-y w)(snake-tail w)(snake-trailxy w)(snake-applexy w)))]
    [(string=? x "down") (if (string=? (snake-mvm w) "up") w (make-snake "down" (snake-x w)(snake-y w)(snake-tail w)(snake-trailxy w)(snake-applexy w)))]
    [(string=? x "left") (if (string=? (snake-mvm w) "right") w (make-snake "left" (snake-x w)(snake-y w)(snake-tail w)(snake-trailxy w)(snake-applexy w)))]
    [(string=? x "right") (if (string=? (snake-mvm w) "left") w (make-snake "right" (snake-x w)(snake-y w)(snake-tail w)(snake-trailxy w)(snake-applexy w)))]
    [else w]))

(define (tick x)
  (cond
    [(or (= (snake-x x) -30)(= (snake-x x) 600)(= (snake-y x) -30)(= (snake-y x) 600)(tailpos x 0))(make-snake "lost" (snake-x x)(snake-y x)(snake-tail x)(snake-trailxy x)(snake-applexy x))]
    [(string=? (snake-mvm x) "up") (cond [(and (= (snake-x x) (posn-x (snake-applexy x)))(= (snake-y x) (posn-y (snake-applexy x))))
                                        (make-snake "up" (snake-x x)(+ (snake-y x) -30)(+ (snake-tail x) 1)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                       [else (make-snake "up" (snake-x x)(+ (snake-y x) -30)(snake-tail x)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(snake-applexy x))])]
    [(string=? (snake-mvm x) "down") (cond [(and (= (snake-x x) (posn-x (snake-applexy x)))(= (snake-y x) (posn-y (snake-applexy x))))
                                          (make-snake "down" (snake-x x)(+ (snake-y x) 30)(+ (snake-tail x) 1)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                         [else (make-snake "down" (snake-x x)(+ (snake-y x) 30)(snake-tail x)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(snake-applexy x))])]
    [(string=? (snake-mvm x) "left") (cond [(and (= (snake-x x) (posn-x (snake-applexy x)))(= (snake-y x) (posn-y (snake-applexy x))))
                                          (make-snake "left" (+ (snake-x x) -30)(snake-y x)(+ (snake-tail x) 1)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                         [else (make-snake "left" (+ (snake-x x) -30)(snake-y x)(snake-tail x)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(snake-applexy x))])]
    [(string=? (snake-mvm x) "right") (cond [(and (= (snake-x x) (posn-x (snake-applexy x)))(= (snake-y x) (posn-y (snake-applexy x))))
                                           (make-snake "right" (+ (snake-x x) 30)(snake-y x)(+ (snake-tail x) 1)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                          [else (make-snake "right" (+ (snake-x x) 30)(snake-y x)(snake-tail x)(if (>(length(snake-trailxy x))(snake-tail x))(append (list-tail (snake-trailxy x) 1)(list (make-posn (snake-x x)(snake-y x))))(if (eq? (snake-trailxy x) '()) (list (make-posn (snake-x x)(snake-y x))) (append (snake-trailxy x)(list (make-posn (snake-x x)(snake-y x))))))(snake-applexy x))])]
    [else x]))

(big-bang (make-snake "" 300 300 4 '() (make-posn (* 30 (random 20))(* 30 (random 20))))
  [to-draw d]
  [on-tick tick 0.06]
  [on-key key]
  [name "Snake"])