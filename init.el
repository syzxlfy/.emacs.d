;;
;;2018-9-15
;;子龙山人 21天学会Emacs 视频
;;学习跟随文件 init.el,有一些配置是自己加上的。
;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;管理、更新、使用自已所用的Packages
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                           ("melpa" . "http://elpa.emacs-china.org/melpa/")))
  ;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  )
;; cl - Common Lisp Extension
(require 'cl)
;;add whatever packages you want here
(defvar lfy/packages '(
		       company         ;;自动智能补全包
		       monokai-theme   ;;界面配置包
		       hungry-delete   ;;饥饿删除包
		       smex            ;;按 M-x 后 显示提示
		       swiper          ;;按 C-s 后(搜索) 下面单独开个窗口给提示
		       counsel         ;;???
		       smartparens     ;;智能成对匹配“” () [] {}
		       js2-mode
		       nodejs-repl
		       exec-path-from-shell
		       popwin          ;;when require ,wh(setq company-minimum prefix-length 1) not require
		       web-mode        ;; web-mode 则是一个非常常用很强大的用于编辑前端代码的 Major Mode,使用 M-;
		       ;;就可以注释当前行代码或选中行的代码。
		       expand-region   ;; 扩展选中区域
                       iedit
		       org-pomodoro    ;;Org-pomodoro 是一个番茄时间工作法的插件。
		       helm-ag
		       helm-swoop
		       magit
		       window-numbering	;窗口间切换 M-0 1 2 ...
		       editorconfig     ;;格式化输入
		       ivy

		       ) "default packages")

(setq package-selected-packages lfy/packages)

(defun lfy/packages-installed-p()
  (loop for pkg in lfy/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))
(unless (lfy/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg lfy/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(tool-bar-mode t) ;;工具栏显示(t 或 nil)
(menu-bar-mode t) ;;菜单栏显示
(electric-indent-mode t) ;;自动缩进
(setq inhibit-splash-screen t) ;; 抑制启动显示屏幕
(scroll-bar-mode -1)

;; (when (version<= "26.0.50" emacs-version )
;;   (global-display-line-numbers-mode))
;;显示行号与列号
(global-linum-mode 1)
(column-number-mode 1)
(setq linum-format " %d ")
;;关闭org-mode的行号
;; (add-hook 'org-mode-hook (lambda () (linum-mode 0)))

;;自定义buffer头
;;显示更多的buffer标题信息
(setq frame-title-format
      '("" " LFY ☺ "
        (:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name)) "%b"))))

;;保存时自动清除行尾空格及文件结尾空行
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;tab&空格
(setq indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)

;;常用 C-a C-e C-d C-w 光标至 头 尾 向前删除 向后删除, 后面设置了更高效的C-w
;; (global-set-key (kbd "C-w") 'backward-kill-word)

;;逗号后自动加空格
;; (global-set-key (kbd ",")
;;                 #'(lambda ()
;;                     (insert ", ")))

;;;; 快速打开配置文件
;;启动后自动进入*scartch* buffer中，按 F5 后快速打开init.el文件，并按init.el配置
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f5>") 'open-my-init-file) ;;这一行代码，将函数 open-init-file 绑定到 <F5> 键上

(global-company-mode t) ;;自动补全

;; 1.make cursor style to bar (setq设置的变量， 当前BUffer有效，setq-default 设置全局变量）
(setq-default cursor-type 'bar) ;;改变光标样式（默认为一黑块状）
;; 2.Disable backup file
;;禁止备份文件
(setq make-backup-files nil)

;; 3.Enable recentf-mode, 保留最近打开的文件列表，以便快速打开。
(require 'recentf)
(recentf-mode t)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;4. Bring electric-indent-mode back
;; (electric-indent-mode t) ;;自动缩进.文件开始处已设置

;;5. Add delete selection mode（输入的内容代替选中部分）
(delete-selection-mode t)

;; 1. Open with full screen 启动时窗体最大化
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; 2. Show match parents 括号匹配
;;(添加一个钩子) 启动括号匹配
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 3. Highlight current line (高亮当前行)
(global-hl-line-mode t)

;;装载monokai-thene 界面
(load-theme 'monokai t)

;;装载hungry-delete(一种高效删除模式)
(require 'hungry-delete)
(global-hungry-delete-mode)

;;Config for smex，为 M-x 命令添加提示
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
					; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)

;;配置swiper,替代isearch,使用ivy来显示所有匹配的目录。
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "C-h f") 'counsel-describe-function)
;;(global-set-key (kbd "C-h v") 'counsel-describe-variable)

;;自动匹配() "" [] {}等，成对出现
(require 'smartparens-config)
;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode);;指定某一种模式下使用smartparens
(smartparens-global-mode t)  ;;每种模式下均可使用smartparens
;;smartparens-global-mode 可以使鼠标在括号上是高亮其所匹配的另一半括号，然而我们想要光标 ;;在括号内时就高亮包含内容的两个括号，使用下面的代码就可以做到这一点。
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))
;;在 Emacs Lisp 中我们 有时候只需要一个 ' 但是 Emacs 很好心的帮我们做了补全''，但这并不是我们需要的。
;;我们可以通过下面的代码来让使 Emacs Lisp 在 Emacs中的编辑变得更方便.
(sp-local-pair '(emacs-lisp-mode lisp-interaction-mode) "'" nil :actions nil)

;;实战 配置js2-mode and start to write javascript
(require 'nodejs-repl)
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;三个重要的快捷键：查找函数(C-h C-f)' 、查找变量(C-h C-v)、查找快捷键 (C-h C-k)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;;when require ,wh(setq company-minimum prefix-length 1) not require
;; popwin 插件可以自动将光标移动到新创建的窗口中。
(require 'popwin)
(popwin-mode t)

;;确认某个命令时需要输入 (yes or no) 比较麻烦，设置一个别名将其简化为只输入 (y or n) 。
(fset 'yes-or-no-p 'y-or-n-p)

;;设置ORG-Mode 下自动换行，其它模式也可以
(global-visual-line-mode 1)

;;使ORG文件中的源码能高亮显示。添加 Org-mode 文本内语法高亮
(require 'org)
(setq org-src-fonttify-natively t)

;; ;; ;;简单的GTD配置
;; ;; ;;设置默认 Org Agenda 文件目录
;; (setq org-agenda-files '("~/Lfy_Study/org"))
;; ;; ;; 设置 org-agenda 打开快捷键
;; ;; ;; 两个常用 C-c C-s scheduled items
;; ;; ;;         C-c C-d set deadline of items
;; (global-set-key (kbd "C-c a") 'org-agenda)

;; ;;配置代码来设置一个模板（其中设置了待办事项的优先级还有触发键），可以实现快速记笔记
;; (setq org-capture-templates
;;       '(("t" "Todo" entry (file+headline "~/Lfy_Study/org/gtd.org" "工作安排")
;; 	 "* TODO [#B] %?\n  %i\n"
;; 	 :empty-lines 1)))
;; ;;绑定一个快捷键，r aka Remember
;; (global-set-key (kbd "C-c r") 'org-capture)

;;;;子龙山人的ORG—GTD配置, 目录改为自己的
(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")
;; define the refile targets
(defvar org-agenda-dir "" "gtd org files location")
(setq-default org-agenda-dir "~/Lfy_Study/org/")
(setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
(setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
(setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
(setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-files (list org-agenda-dir))

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
  ;; (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
  ;;   "." 'spacemacs/org-agenda-transient-state/body)
  )

;; ;; the %i would copy the selected text into the template
;;   ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
;;   ;;add multi-file journal
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-agenda-file-gtd "Workspace")
         "* TODO [#B] %?\n  %i\n"
         :empty-lines 1)
        ("n" "notes" entry (file+headline org-agenda-file-note "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("b" "Blog Ideas" entry (file+headline org-agenda-file-note "Blog Ideas")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("s" "Code Snippet" entry
         (file org-agenda-file-code-snippet)
         "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
        ("w" "work" entry (file+headline org-agenda-file-gtd "Cocos2D-X")
         "* TODO [#A] %?\n  %i\n %U"
         :empty-lines 1)
        ("c" "Chrome" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n %(zilongshanren/retrieve-chrome-current-tab-url)\n %i\n %U"
         :empty-lines 1)
        ("l" "links" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n  %i\n %a \n %U"
         :empty-lines 1)
        ("j" "Journal Entry"
         entry (file+datetree org-agenda-file-journal)
         "* %?"
         :empty-lines 1)))

;;An entry without a cookie is treated just like priority ' B '.
;;So when create new task, they are default 重要且紧急
(setq org-agenda-custom-commands
      '(
        ("w" . "任务安排")
        ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
        ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
        ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
        ("b" "Blog" tags-todo "BLOG")
        ("p" . "项目安排")
        ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"Workspace\"")
        ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"LFYNOTE\"")
        ("W" "Weekly Review"
         ((stuck "") ;; review stuck projects as designated by org-stuck-projects
          (tags-todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          ))))

;; ;; 设置 org-agenda 打开快捷键
;; ;; 两个常用 C-c C-s scheduled items
;; ;;         C-c C-d set deadline of items
(global-set-key (kbd "C-c a") 'org-agenda)

;;配置代码来设置一个模板（其中设置了待办事项的优先级还有触发键），可以实现快速记笔记
;;绑定一个快捷键，r aka Remember
(global-set-key (kbd "C-c r") 'org-capture)




;;Org-pomodoro 是一个番茄时间工作法的插件（更多关于这个工作法的信息可以在这里找到）。 它的 GitHub 地址在这里。在 (require 'org-pomodoro) 后可以通过 ;;Customize-group 来对其进行设置，包括不同休息种类的时长。
(require 'org-pomodoro)
(setq pomodoro-break-time 2)
(setq pomodoro-long-break-time 5)
(setq pomodoro-work-time 15)
(setq-default mode-line-format
              (cons '(pomodoro-mode-line-string pomodoro-mode-line-string)
                    mode-line-format))


;;Emacs 自带的 HTML Mode 使用起来并不是那么的方便，而 web-mode 则是一个非常常用也 很强大的用于编辑前端代码的 Major ;;Mode（你可以在这里找到更多关于它的信息）。首先我们需要安装它，照例我们需要将其添加至我们的插件列表中去。(Web-mode)前面已安装
;;在安装完成后我们就可以开始配置它了，首先我们需要做的是将所有的 *.html 文件都使 用 web-mode 来打开。
;;首先我们需要安装它，照例我们需要将其添加至我们的插件列表中去。
;;使用 M-; 就可以智能注释当前行代码或选中行的代码(各种编程语言的注释是不同的)
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       '(("\\.html\\'" . web-mode))
       auto-mode-alist))

;; 接下来我们来做更多细节的配置，首先是缩进的大小的设置。因为 web-mode 支持在 HTML ;;文件中存在多语言，所以我们可以对不同的语言的缩进做出设置。下面的代码用于设置初始 的代码缩进，
(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
  (setq web-mode-code-indent-offset 2)   ; web-mode, js code in html file
  )
(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

;;下面的函数可以用于在两个空格和四个空格之间进行切换，
(defun my-toggle-web-indent ()
  (interactive)
  ;; web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

  (setq indent-tabs-mode nil))
(global-set-key (kbd "C-c t i") 'my-toggle-web-indent)


;;下面的代码用于配置 Occur Mode 使其默认搜索当前被选中的或者在光标下的字符串：
(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
	    (buffer-substring-no-properties
	     (region-beginning)
	     (region-end))
	  (let ((sym (thing-at-point 'symbol)))
	    (when (stringp sym)
	      (regexp-quote sym))))
	regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-dwim)

;; Occur 可以用于显示变量或函数的定义，我们可以通过 popwin 的 customize-group 将定 义显示设置为右边而不是默认的底部（ customize-group > popwin > ;;Popup Window Position 设置为 right），也可以在这里对其宽度进行调节。
;; Occur 与普通的搜索模式不同的是，它可以使用 Occur-Edit Mode (在弹出的窗口中按 e 进入编辑模式) 对搜索到的结果进行之间的编辑。
;; imenu 可以显示当前所有缓冲区的列表，下面的配置可以让其拥有更精确的跳转，
(defun js2-imenu-make-index ()
  (interactive)
  (save-excursion
    ;; (setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
    (imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("test" "\\s-*test\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("before" "\\s-*before\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("after" "\\s-*after\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^var[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*{" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
			       ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\)" 1)))))
(add-hook 'js2-mode-hook
	  (lambda ()
	    (setq imenu-create-index-function 'js2-imenu-make-index)))
(global-set-key (kbd "M-s i") 'counsel-imenu)

;; 将 expand-region 添加至我们的插件列表中，重启 Emacs 安装插件。再为其绑定一个快捷键，
;; 使用这个插件可以使我们更方便的选中一个区域。
(global-set-key (kbd "C-=") 'er/expand-region)

;; iedit 是一个可以同时编辑多个区域的插件，它类似 Sublime Text 中的多光标编辑。它的 GitHub 仓库在这里。
;; 我们将其绑定快捷键以便更快捷的使用这个模式（M-s e 为默认快捷键），
(global-set-key (kbd "M-s e") 'iedit-mode)

;; 在 Company-mode 中，默认使用M-n M-p来上下移动光标选择，下面设置后，用 C-n 与 C-p 来移动选择补全项
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil) ;;禁用M-n
  (define-key company-active-map (kbd "M-p") nil) ;;禁用M-p
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; use aspell as ispell backend
;;;; use American English as ispell default dictionary
(setq-default ispell-program-name "D:/msys64/usr/bin/aspell.exe")
(ispell-change-dictionary "american" t)
(setq text-mode-hook '(lambda() (flyspell-mode t) ))

;;缩写补全
;;使用下面的代码我们可以开启 abbrev 模式并定义一个缩写表，每当我们输入下面的缩写并以空格结束时，
;;Emacs 就会将其自动展开成为我们所需要的字符串。

(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)
(define-abbrev-table 'global-abbrev-table '(
					    ;; Shifu
					    ("lf" "LiFu")
					    ;;yu
					    ("bh" "BianHai")
					    ;; My
					    ("ept-" " @163.com")
                                            ;;gongyony
					    ("syzx-" " @163.com")
					    ))

;; Hippie 补全
;; Company 有时候补全功能并不是非常理想，这时就可以使用 Hippie Expand 来完成补全。 Company Mode 补全效果不理想的原因是在不同的区域中会使用不同的后端函数来完成补全， 但是当后端补全函数不能被激活时，则补全就不会被激活。
;; 我们可以将下面的代码加入到我们的配置文件中，来增强 Hippie Expand 的功能，然后将其绑定为快捷键，使我们可以更方便的使用它。

(setq hippie-expand-try-function-list '(try-expand-debbrev
                                        try-expand-debbrev-all-buffers
                                        try-expand-debbrev-from-kill
                                        try-complete-file-name-partially
                                        try-complete-file-name
                                        try-expand-all-abbrevs
                                        try-expand-list
                                        try-expand-line
                                        try-complete-lisp-symbol-partially
                                        try-complete-lisp-symbol))
(global-set-key (kbd "<f8>") 'hippie-expand)



;;ag它是非常快速的命令 行搜索工具，它是 Linux 的所有搜索工具中最快的。使用 ag 前我们需要进行安装，
;;# Windows 下通过 msys2 安装（确保在 path 中）
;;pacman -S mingw-w64-i686-ag # 32 位电脑
;;pacman -S mingw-w64-x86_64-ag # 64 位电脑
;;安装好 ag 后我们就可以安装 helm-ag 插件了。在安装完成后可以为其设置快捷键，
;;下面配置未成功
(require 'helm-ag)
(global-set-key (kbd "C-c p s") 'helm-do-ag-project-root)
(global-set-key (kbd "<f7>") 'helm-do-ag-project-root)

;;(require 'org-octopress)
;;(setq org-octopress-directory-top       "~/Lfy_Study/octopress/source")
;;(setq org-octopress-directory-posts     "~/Lfy_Study/octopress/source/_posts")
;;(setq org-octopress-directory-org-top   "~/Lfy_Study/octopress/source")
;;(setq org-octopress-directory-org-posts "~/Lfy_Study/octopress/source/blog")
;;(setq org-octopress-setup-file          "~/Lfy_Study/setupfile.org")

;;查看git状态，在init.el中添加快捷键绑定
(global-set-key (kbd "C-x g") 'magit-status)


;; 几个实用操作
;; 1、 在行末或行中位置删除整行 ;;在emacs默认设置中，要想删除整行，需要先C-a跳到行首，然后使用C-k来删除整行，有些不方便。
;;通过一下配置，可以使用C-w来删除整行（操作时不用事先选中整行）.
;;同时不影响原有的剪切功能。M-w也可以在不事先选中整行的情况下复制整行。
(defadvice kill-ring-save (before slickcopy activate compile)
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
	   (line-beginning-position 2)))))
(defadvice kill-region (before slickcut activate compile)
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
	   (line-beginning-position 2)))))

;; 2、优化注释功能
;;Emacs的默认设置中，M-;可以起到注释的作用，但是有不方便的地方：必须在选中一部分区域后才能进行注释。
;;通过如下配置，可以达到以下效果：当光标位于行尾时，M-;在行尾进行注释；当光标位于其他位置时，M-;起到注释该行的作用；
;;当选中一部分区域时，M-;起到注释该区域的作用。
(defun qiang-comment-dwim-line (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; 3、设置透明效果
;; 我觉得这个很有用，特别是需要一边写代码一边看参照其他文档时。按F12键可以一键切换透明度，非常方便
;;set transparent effect
(setq alpha-list '((100 100) (95 65) (85 55) (75 45) (65 35)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))                ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
  )
(global-set-key [(f12)] 'loop-alpha)

;; 将子窗口自动编号,然后按 M-0…9跳转(最爱),  安装window-numbering.el,然后在.emacs中添加以下代码.
;; 在emacs的默认设置中，需要使用C-x, o来进行窗口切换，颇为不便，特别是窗口数量比较大的时候。通过以下设置，可以
;; 使用M-1/M-2/M-3/.../M-9来快速切换到第1/2/3/.../9窗口（窗口上有编号）。
;; C-x 0：关闭当前窗口
;; C-x 1：关闭当前窗口以为的其他窗口
;; C-x 2：水平分割窗口
;; C-x 3：垂直分割窗口
;; C-x 4 0：关闭当前窗口和缓冲
;; C-x 4 b：在另一窗口打开缓冲（如果当前只有一个窗口将分割一个新窗口）
;; C-x 4 f：在另一窗口打开文件（…同上）
;; C-x o：在多个窗口中循环切换
(require 'window-numbering)
(window-numbering-mode 1)
;; If you want to affect the numbers, use window-numbering-before-hook or window-numbering-assign-func.
;; For instance, to always assign the calculator window the number 9, add the following to your .emacs:
(setq window-numbering-assign-func
      (lambda () (when (equal (buffer-name) "*Calculator*") 9)))


;; 不安装任何插件，使用emacs格式化（整理）源程序，
;; 1、如果想要整理整个文件
;; M-x mark-whole-buffer  或者 C-x h  选中整个文件
;; M-x indent-region      或者 C-M-\  格式化选中
;; 2、只是整理某个函数
;; M-x mark-defun       或者 C-M-h  选中函数
;; M-x indent-region    或者 C-M-\  格式化

;;安装插件Editorconfig后
;;将代码格式化，设置快捷键 F6
(require 'editorconfig)
(editorconfig-mode 1)
(global-set-key (kbd "<f6>") 'editorconfig-format-buffer)

;;让 Emacs 可以直接打开和显示图片。
(setq auto-image-file-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.08)
 '(company-minimum-prefix-length 1)
 ;; '(org-agenda-files t)
 '(org-pomodoro-length 50))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Microsoft YaHei Mono" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

;; ;; 此配置文件中设置的所有快捷键列表
;; (global-set-key (kbd "<f5>") 'open-my-init-file)
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key "\C-s" 'swiper)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "C-h C-f") 'find-function)
;; (global-set-key (kbd "C-h C-v") 'find-variable)
;; (global-set-key (kbd "C-h C-k") 'find-function-on-key)
;; (global-set-key (kbd "C-c a") 'org-agenda)
;; (global-set-key (kbd "C-c r") 'org-capture)
;; (global-set-key (kbd "C-c t i") 'my-toggle-web-indent)
;; (global-set-key (kbd "M-s o") 'occur-dwim)
;; (global-set-key (kbd "M-s i") 'counsel-imenu)
;; (global-set-key (kbd "C-=") 'er/expand-region)
;; (global-set-key (kbd "M-s e") 'iedit-mode)
;; (global-set-key (kbd "C-c p s") 'helm-do-ag-project-root)
;; (global-set-key (kbd "<f6>") 'editorconfig-format-buffer)
;; (global-set-key (kbd "<f7>") 'helm-do-ag-project-root)
;; (global-set-key (kbd "<f8>") 'hippie-expand)
;; (global-set-key (kbd "C-x g") 'magit-status)
;; (global-set-key "\M-;" 'qiang-comment-dwim-line)
;; (global-set-key [(f12)] 'loop-alpha)
