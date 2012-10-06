;;; text-language.el --- tracking, setting, guessing language of text

;; Author: Peter Eisentraut <peter@eisentraut.org>
;; Keywords: i18n wp

;;; Commentary:
;;
;; needs https://bitbucket.org/spirit/guess_language


(make-local-variable 'text-language-current)

(defvar text-language-set-functions nil
  "List of functions to be called when the text language has been
set, with a string for the language as argument.")

(defvar text-language-guessed-functions nil
  "List of functions to be called when the text language has been
guuessed, with the string for the language as argument.  A
function can return a nil value to cancel the setting of the
current language based on the guess.")

(defun text-language-set-language (lang)
  "Set the text language of the current buffer.
Run the (abnormal) hook text-language-set-functions with it."
  (interactive)
  (setq text-language-current lang)
  (run-hook-with-args 'text-language-set-functions lang))

(defun chomp (str)
  (replace-regexp-in-string "\n+\\'" "" str))

(defun text-language-guess ()
  "Guess the language of the current buffer and set it."
  (interactive)
  (let* ((cb (current-buffer))
         (gl (chomp
              (with-temp-buffer
                (call-process "python3" (buffer-file-name cb) t nil "-m" "guess_language" "-")
                (buffer-string)))))
    (when (run-hook-with-args-until-failure 'text-language-guessed-functions gl)
      (text-language-set-language gl))))

(add-hook 'text-language-guessed-functions
          (lambda (lang) (message "Guessed language: %s" lang)))

(define-minor-mode text-language-mode
  "Toggle minor mode that tracks the text language."
  :lighter (:eval (format " TL:%s" text-language-current)))

(define-minor-mode text-language-guess-mode
  "Turn on or off hooks that automatically guess the text language."
  :lighter " GL"
  (add-hook 'find-file-hook 'text-language-guess)
  (add-hook 'after-save-hook 'text-language-guess))

(add-hook 'text-mode-hook 'text-language-mode)
(add-hook 'text-mode-hook 'text-language-guess-mode)

(when (fboundp 'ispell-change-directory)
  (add-hook 'text-language-set-functions 'ispell-change-dictionary))

(provide 'text-language)
