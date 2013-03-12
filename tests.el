(ert-deftest test-chomp ()
  (should (equal (chomp "foo") "foo"))
  (should (equal (chomp "bar\n") "bar")))

(ert-deftest test-guess-english ()
  :expected-result :failed
  (with-temp-buffer
    (insert "something in English")
    (text-language-guess)
    (should (equal text-language-current "en"))))

(ert-deftest test-guess-german ()
  :expected-result :failed
  (with-temp-buffer
    (insert "etwas auf deutsch")
    (text-language-guess)
    (should (equal text-language-current "de"))))
