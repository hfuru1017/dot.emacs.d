(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(tab-always-indent (quote always))
 '(tab-stop-list nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq x-select-enable-clipboard t)

(global-set-key "\C-h" 'delete-backward-char)
(setq scroll-step 1)

(defun my-c-mode-hook ()
  (c-set-style "linux")
  (setq tab-width 4)
  (setq c-basic-offset tab-width)
  (setq c-auto-newline nil)
  (setq c-tab-always-indent nil)
)

(defun my-c-common-mode ()
  (c-toggle-hungry-state 1))
(add-hook 'c-mode-common-hook 'my-c-common-mode)

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(eval-when-compile (require 'ps-mule nil t))
(setq ps-paper-type        'a4 ;paper size
      ps-lpr-command       "lpr"
      ps-lpr-switches      '("-o Duplex=DuplexNoTumble")
      ps-printer-name      "HL3170CDW"   ; your printer name
      ps-multibyte-buffer  'non-latin-printer ;for printing Japanese
      ps-n-up-printing     1 ;print n-page per 1 paper

      ;; Margin
      ps-left-margin       20
      ps-right-margin      20
      ps-top-margin        20
      ps-bottom-margin     20
      ps-n-up-margin       20
      ;; Header/Footer setup
      ps-print-header      t            ;buffer name, page number, etc.
      ps-print-footer      nil          ;page number

      ;; font
      ps-font-size         '(10 . 12)
      ps-header-font-size  '(8 . 10)
      ps-header-title-font-size '(8 . 10)
      ps-header-font-family 'Helvetica    ;default
      ps-line-number-font  "Times-Italic" ;default
      ps-line-number-font-size 8

      ;; line-number
      ps-line-number       t ; t:print line number
      ps-line-number-start 1
      ps-line-number-step  1
      )

;(global-set-key [f10] 'ps-print-buffer)
;(global-set-key [f12] 'ps-print-region)


;;(cua-mode t)
;;(setq cua-enable-cua-keys nil)

(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;対応する確固の強調
(show-paren-mode 1)

;; バックアップファイルを作成しない
(setq make-backup-files nil)
(setq auto-save-default nil)

;テーマカラー
;(require 'color-theme)
;(color-theme-initialize)
;(color-theme-arjen)

;エスケープシーケンスを処理
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
          "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;;汎用機の SPF (mule みたいなやつ) には
;;画面を 2 分割したときの 上下を入れ替える swap screen
;;というのが PF 何番かにわりあてられていました。
(defun swap-screen()
  "Swap two screen,leaving cursor at current window."
  (interactive)
  (let ((thiswin (selected-window))
        (nextbuf (window-buffer (next-window))))
    (set-window-buffer (next-window) (window-buffer))
    (set-window-buffer thiswin nextbuf)))
(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
        (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))




;;;====================================
;;;; Buffer 設定
;;;===================================
;;; iswitchb は、バッファ名の一部の文字を入力することで、
;;; 選択バッファの絞り込みを行う機能を実現します。
;;; バッファ名を先頭から入力する必要はなく、とても使いやすくなります。
(require 'edmacro)
(iswitchb-mode 1) ;;iswitchbモードON
(defun iswitchb-local-keys ()
  (mapc (lambda (K) 
          (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("<right>" . iswitchb-next-match)
          ("<left>"  . iswitchb-prev-match)
          ("<up>"    . ignore             )
          ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

(setq iswitchb-buffer-ignore '("^ " "*"))
;;setq iswitchb-buffer-ignore '("^\\*"))
(setq iswitchb-default-method 'samewindow)



(defun my-swap-cursor()
  "Swap cursor in two window."
  (interactive)
  (other-window 1) )
;(global-set-key [f5] 'my-swap-cursor)

(defun my-kill-ring-save()
  "Copy to kill-ring buffer and discard mark point."
  (interactive)
  (kill-ring-save (region-beginning) (region-end)) 
  (keyboard-quit) )

;Fnキーの定義　MIFESっぽい感じで定義してます。　簡単なので
(global-set-key [f2] 'rgrep)
(global-set-key [f3] 'iswitchb-buffer)
(global-set-key [s-f4] 'swap-screen)
(global-set-key [f4] 'swap-screen-with-cursor)
(global-set-key [f5] 'revert-no-ask)
(global-set-key [f6] 'set-mark-command)
(global-set-key [f7] 'kill-region)
(global-set-key [f8] 'my-kill-ring-save)
(global-set-key [f9] 'mytab)
(global-set-key [f10] 'compile)
;(global-set-key [f11] 'mytab)
(global-set-key [f12] 'shell)

;; tab
(defun mytab()
  (interactive)
  (quoted-insert TAB))

;; rgrep
(setq grep-files-aliases '(("asm" . "*.[sS]")
                           ("c" . "*.c")
                           ("cc" . "*.cc *.cxx *.cpp *.C *.CC *.c++")
                           ("cchh" . "*.cc *.[ch]xx *.[ch]pp *.[CHh] *.CC *.HH *.[ch]++")
                           ("hh" . "*.hxx *.hpp *.[Hh] *.HH *.h++")
                           ("ch" . "*.[cChH] *.[cChH][pP]* *.[cC][cC] *.[hH][hH] *.[chCH][xX]* *.[rR][cC]")
                           ("ch2" . "*.[cChH] *.[cChH][pP]* *.[cC][cC] *.[hH][hH] *.[chCH][xX]* *.[rR][cC] *.vcxproj* *.ds* *.rc*")
                           ("cs" . "*.application *.aspx *.ascx *.bat *.config *.cs *.csproj *.css *.disco *.js *.manifest *.py *.resx *.sitemap *.user *.xml *.Master")
                           ("el" . "*.el")
                           ("h" . "*.h")
                           ("l" . "[Cc]hange[Ll]og*")
                          ("m" . "[Mm]akefile*")
                           ("tex" . "*.tex")
                           ("texi" . "*.texi")
                           ("disco" . "*.[cChH] *.[cChH][pP]* *.[cC][cC] *.[hH][hH] *.[chCH][xX]* *.[rR][cC] *.[sS][dD]* *.[dD][dD][fF] *.[dD][aA][tT] *.[mM][sS][rR] *.[dD][fF][dD] *.[cC][lL][nN] *.[sS][sS][rR]")))

(defun revert-no-ask ()
  (interactive)
  (revert-buffer t t))


;;
;; whitespace
;;

(require 'whitespace)
(setq whitespace-style '(face
                         trailing
                         tabs
                         ;;empty
                         space-mark
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\\])))

(global-whitespace-mode 1)


