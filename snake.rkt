;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname snake) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct aaa [mvm x y tail trailxy applexy])

(define (list-tail l n)
  (remove (car l) l))

(define (tailrepeat s n)
  (cond
    [(= (- (length (aaa-trailxy s)) 1) n) (underlay/align/offset "left""top" (square 600 0 "red") (posn-x (list-ref (aaa-trailxy s) n))(posn-y (list-ref (aaa-trailxy s) n)) (square 30 255 (color 0 0 0 225)))]
    [(>= (length (aaa-trailxy s)) 1) (overlay(underlay/align/offset "left""top" (tailrepeat s (+ n 1)) (posn-x (list-ref (aaa-trailxy s) n))(posn-y (list-ref (aaa-trailxy s) n))(square 30 255 (color 0 0 0 225)))(square 600 0 "red"))]
    [else (circle 1 0 "red")]))

(define (tailpos s n)
  (cond
    [(< (- (length (aaa-trailxy s)) 1) n) #false]
    [(<(length (aaa-trailxy s)) 3) #false]
    [(boolean=? #false (and (= (aaa-x s) (posn-x (list-ref (aaa-trailxy s) n)))(= (aaa-y s) (posn-y (list-ref (aaa-trailxy s) n))))) (tailpos s (+ n 1))]
    [else #true]))

(define (d x)
  (if (string=? (aaa-mvm x) "lost")
      (overlay/offset (text (string-append "         You lost\n""         Score: " (number->string (-(aaa-tail x)4)) "\nPress enter to reset") 60 "indigo") 0 0 (square 600 0 "red"))
      (overlay (tailrepeat x 0)
               (underlay/align/offset "left" "top"
                                      (underlay/align/offset "left" "top"
                                                             (empty-scene 600 600)
                                                             (posn-x (aaa-applexy x))(posn-y (aaa-applexy x)) 
                                                             (square 30 255 "red"))
                                      (aaa-x x) (aaa-y x)
                                      (square 30 255 (color 0 0 0 225))))))

(define (key w x)
  (cond
    [(string=? x "\r") (make-aaa "" 300 300 4 '() (make-posn (* 30 (random 20))(* 30 (random 20))))]
    [(string=? x "up") (if (string=? (aaa-mvm w) "down") w (make-aaa "up" (aaa-x w)(aaa-y w)(aaa-tail w)(aaa-trailxy w)(aaa-applexy w)))]
    [(string=? x "down") (if (string=? (aaa-mvm w) "up") w (make-aaa "down" (aaa-x w)(aaa-y w)(aaa-tail w)(aaa-trailxy w)(aaa-applexy w)))]
    [(string=? x "left") (if (string=? (aaa-mvm w) "right") w (make-aaa "left" (aaa-x w)(aaa-y w)(aaa-tail w)(aaa-trailxy w)(aaa-applexy w)))]
    [(string=? x "right") (if (string=? (aaa-mvm w) "left") w (make-aaa "right" (aaa-x w)(aaa-y w)(aaa-tail w)(aaa-trailxy w)(aaa-applexy w)))]
    [else w]))

(define (tick x)
  (cond
    [(or (= (aaa-x x) -30)(= (aaa-x x) 600)(= (aaa-y x) -30)(= (aaa-y x) 600)(tailpos x 0))(make-aaa "lost" (aaa-x x)(aaa-y x)(aaa-tail x)(aaa-trailxy x)(aaa-applexy x))]
    [(string=? (aaa-mvm x) "up") (cond [(and (= (aaa-x x) (posn-x (aaa-applexy x)))(= (aaa-y x) (posn-y (aaa-applexy x))))
                                        (make-aaa "up" (aaa-x x)(+ (aaa-y x) -30)(+ (aaa-tail x) 1)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                       [else (make-aaa "up" (aaa-x x)(+ (aaa-y x) -30)(aaa-tail x)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(aaa-applexy x))])]
    [(string=? (aaa-mvm x) "down") (cond [(and (= (aaa-x x) (posn-x (aaa-applexy x)))(= (aaa-y x) (posn-y (aaa-applexy x))))
                                          (make-aaa "down" (aaa-x x)(+ (aaa-y x) 30)(+ (aaa-tail x) 1)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                         [else (make-aaa "down" (aaa-x x)(+ (aaa-y x) 30)(aaa-tail x)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(aaa-applexy x))])]
    [(string=? (aaa-mvm x) "left") (cond [(and (= (aaa-x x) (posn-x (aaa-applexy x)))(= (aaa-y x) (posn-y (aaa-applexy x))))
                                          (make-aaa "left" (+ (aaa-x x) -30)(aaa-y x)(+ (aaa-tail x) 1)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                         [else (make-aaa "left" (+ (aaa-x x) -30)(aaa-y x)(aaa-tail x)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(aaa-applexy x))])]
    [(string=? (aaa-mvm x) "right") (cond [(and (= (aaa-x x) (posn-x (aaa-applexy x)))(= (aaa-y x) (posn-y (aaa-applexy x))))
                                           (make-aaa "right" (+ (aaa-x x) 30)(aaa-y x)(+ (aaa-tail x) 1)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(make-posn (* 30 (random 20))(* 30 (random 20))))]
                                          [else (make-aaa "right" (+ (aaa-x x) 30)(aaa-y x)(aaa-tail x)(if (>(length(aaa-trailxy x))(aaa-tail x))(append (list-tail (aaa-trailxy x) 1)(list (make-posn (aaa-x x)(aaa-y x))))(if (eq? (aaa-trailxy x) '()) (list (make-posn (aaa-x x)(aaa-y x))) (append (aaa-trailxy x)(list (make-posn (aaa-x x)(aaa-y x))))))(aaa-applexy x))])]
    [else x]))

(big-bang (make-aaa "" 300 300 4 '() (make-posn (* 30 (random 20))(* 30 (random 20))))
  [to-draw d]
  [on-tick tick 0.06]
  [on-key key]
  [name "Snake"])