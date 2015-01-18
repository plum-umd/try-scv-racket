#lang racket/base
(provide make-ev make-ev-rkt)
(require racket/sandbox
         ;; just load it to share instances
         (only-in soft-contract))


;; make-ev : -> evaluator

;; Make sandboxed soft-contract evaluator
(define (make-ev)
  (parameterize ([sandbox-output 'string]
                 [sandbox-error-output 'string]
                 [sandbox-propagate-exceptions #f]
                 [sandbox-memory-limit 400]
                 [sandbox-eval-limits (list 20 400)]
                 [sandbox-namespace-specs
                  (append (sandbox-namespace-specs) '(soft-contract))]
                 [sandbox-path-permissions (list* ; FIXME hack²
                                            (list 'exists "/")
                                            ;; execute below is fine for now because SCV doesn't have side effects
                                            ;; we need this to run Z3
                                            (list 'execute "/bin/sh")
                                            '((read #rx#"racket-prefs.rktd")))])
    (make-evaluator 'soft-contract)))

;; Make sandboxed Racket evaluator
(define (make-ev-rkt)
  (parameterize ([sandbox-output 'string]
                 [sandbox-error-output 'string]
                 [sandbox-propagate-exceptions #t]
                 [sandbox-memory-limit 200]
                 [sandbox-eval-limits (list 2 200)]
                 [sandbox-namespace-specs
                  (append (sandbox-namespace-specs) '(racket))]
                 [sandbox-path-permissions '((read #rx#"racket-prefs.rktd"))])
    (make-evaluator 'racket)))