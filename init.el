;;--------------------------------------------------------------------------------------------
;; 文件名：.Spacemacs
;; Time-stamp: <此文件由 syzxg 修改--最后修改时间为：2018年10月09日 15时03分57秒>
;;--------------------------------------------------------------------------------------------
;; 此文件始于2018-9-15
;; 子龙山人 21天学会Emacs 视频
;; 学习跟随文件 init.el
;;
;;
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;管理、更新、使用自已所用的Packages
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  ;;国外最直接的Package下载网站，速度较慢。
  ;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  ;;使用国内清华镜像网站
  (add-to-list 'package-archives '("melpa-cn" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)
  (add-to-list 'package-archives '("gnu-cn" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/") t)
  (add-to-list 'package-archives '("org-cn" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/") t)
)
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
		       org-pomodoro    ;;Org-pomodoro 是一个番茄时间工作法的插件.
                       helm-ag
		       helm-swoop
		       magit
		       youdao-dictionary ;;友道词典

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

;;;; 快速打开配置文件
;;启动后自动进入*scartch* buffer中，按 F5 后打开init.el文件.
(defun open-my-init-file()
(interactive)
(find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f5>") 'open-my-init-file) ;;这一行代码，将函数 open-init-file 绑定到 <F5> 键上
;;
;;以下为界面设置(放置自己喜欢的配置)--开始
(tool-bar-mode t)                           ;;工具栏显示(t 或 nil)
(menu-bar-mode t)                           ;;菜单栏显示
(electric-indent-mode t)                    ;;自动缩进
(setq inhibit-splash-screen t)              ;;抑制启动显示屏幕
(scroll-bar-mode -1)                         ;侧边栏禁用
(setq-default auto-save-default nil)        ;;禁用自动保存(全局型)
;; 启用时间显示设置，在minibuffer的状态条上显示
(display-time-mode t)
;; 使用24小时制
(setq display-time-24hr-format t)
;;显示行号与列号
(global-linum-mode t) ;; 显示行号
(column-number-mode t);; 显示列号
;;自定义buffer头
;;显示更多的buffer标题信息
(setq frame-title-format
      '("" " 道法自然-LFY ☺ "
        (:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name)) "%b"))))
;;保存时自动清除行尾空格及文件结尾空行
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;tab&空格
(setq indent-tabs-mode t)
(setq default-tab-width 4)
(setq tab-width 4)

;;开启行号
(global-linum-mode t)
(setq linum-format " %d ")
(add-hook 'org-mode-hook (lambda () (linum-mode 0)));;若注释掉本行将关闭org-mode时的行号

;;常用 C-a C-e C-d C-w 光标至 头 尾 向前删除 向后删除
(global-set-key (kbd "C-w") 'backward-kill-word)

;;逗号后自动加空格
(global-set-key (kbd ",")
                #'(lambda ()
                    (interactive)
                    (insert ", ")))

;; ;; use apsell as ispell backend
;; (setq-default ispell-program-name "aspell")
;; ;; use American English as ispell default dictionary
;; (ispell-change-dictionary "american" t)


(global-company-mode t) ;;自动补全

;; 1.make cursor style to bar (setq设置的变量， 当前BUffer有效，setq-default 设置全局变量）
(setq-default cursor-type 'bar) ;;改变光标样式（默认为一黑块状）
;; 2.Disable backup file
;;禁止备份文件
(setq make-backup-files nil)

;; 3.Enable recentf-mode
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

;;Config for smex
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
		  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)

 ;;配置swiper,替代isearch,使用ivy来显示所有匹配的目录。
(ivy-mode t)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
;;(global-set-key (kbd "<f6>") 'ivy-resume)
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "C-h f") 'counsel-describe-function)
;;(global-set-key (kbd "C-h v") 'counsel-describe-variable)

;;自动匹配() "" [] {}等，成对出现
(require 'smartparens-config)
;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode);;指定某一种模式下使用smartparens
(smartparens-global-mode t)  ;;每种模式下均可使用smartparens
;;smartparens-global-mode 可以使鼠标在括号上是高亮其所匹配的另一半括号，然而我们想要光标
;;在括号内时就高亮包含内容的两个括号，使用下面的代码就可以做到这一点。
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))

;;在 Emacs Lisp 中我们 有时候只需要一个 ' 但是 Emacs 很好心的帮我们做了补全，但这并不是我们需要的。
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
(require 'popwin)
(popwin-mode t)

;;设置ORG-Mode 下自动换行，其它模式也可以
(global-visual-line-mode t)


;;使ORG文件中的源码能高亮显示。添加 Org-mode 文本内语法高亮
(require 'org)
(setq org-src-fonttify-natively t)

;; 设置默认 Org Agenda 文件目录
(setq org-agenda-files '("~/Lfy_Study/org"))
;; 设置 org-agenda 打开快捷键
;; 常用 C-c C-s scheduled items 开始时间
;; C-c C-d set deadline of items 结束时间
;;C-c r 即时计事; C-c C-t 改变todo状态; C-c C-q 标签TAG设定;
(global-set-key (kbd "C-c a") 'org-agenda)

;;配置代码来设置一个模板（其中设置了待办事项的优先级还有触发键），可以实现快速记笔记
;; (setq org-capture-templates
;;       '(("t" "Todo" entry (file+headline "~/Lfy_Study/org/gtd.org" "工作安排")
;; 	 "* TODO [#B] %?\n  %i\n"
;; 	 :empty-lines 1)))
;;绑定一个快捷键，r aka Remember

;; 使用GTD其实就是如何设置好标题的各项内容，语法总格式：STARS KEYWORD PRIORITY TITLE TAGS
;; 1.STARS(星号)，几级标题几个星号
;; 2.KEYWORD设置(TODO)
;; (setq org-todo-keywords
;;       '(
;;         ;;note笔记 idea想法
;;         ;;todo准备做 done完成 abort中止
;;         (sequence "TODO(t!)" "|" "DONE(d!)" "ABORT(a@/!)" "NOTE(n!)" "IDEA(i!)")
;;         ))
;; 可以定义多系列的TODO关键词，也可以使用中文关键词。
;; 可以在 () 中定义附加选项,包括:
;; 1. 字符:该状态的快捷键
;; 2. ! : 切换到该状态时会自动添加时间戳
;; 3. @ : 切换到该状态时要求输入文字说明
;; 如果同时设定@和!,使用@/!
(setq org-todo-keywords
      '(
	;;(type "工作(w!)" "学习(s!)" "休闲(l!)" "|")
	(sequence "PENDING(p!)" "TODO(t!)"  "|" "DONE(d!)" "ABORT(a@/!)")
    ))
(setq org-todo-keyword-faces
  '(("工作" .      (:background "red" :foreground "white" :weight bold))
    ("学习" .      (:background "white" :foreground "red" :weight bold))
    ("休闲" .      (:foreground "MediumBlue" :weight bold))
    ("PENDING" .   (:background "LightGreen" :foreground "blue" :weight bold))
    ("TODO" .      (:background "DarkOrange" :foreground "black" :weight bold))
    ("DONE" .      (:background "azure" :foreground "Darkgreen" :weight bold))
    ("ABORT" .     (:background "gray" :foreground "black"))
))

;; PRIORITY优先级设置 A、B、C.....
;; 设置优先级范围和默认任务的优先级
;; 在标题上使用 S-UP/DOWN 可以选择和改变任务的优先级。
(setq org-highest-priority ?A)
(setq org-lowest-priority  ?E)
(setq org-default-priority ?B)
;; 设置优先级醒目外观
(setq org-priority-faces
  '((?A . (:background "red" :foreground "white" :weight bold))
    (?B . (:background "DarkOrange" :foreground "white" :weight bold))
    (?C . (:background "yellow" :foreground "DarkGreen" :weight bold))
    (?D . (:background "DodgerBlue" :foreground "black" :weight bold))
    (?E . (:background "SkyBlue" :foreground "black" :weight bold))
    ))

;; 4. TITLE 为标题文本，手工输入你的内容

;; 5. TAG 为标记设置
(setq org-tag-alist '(("work" . ?w)
		      ("home" . ?h)
		      ("study" . ?s)
		      ("laptop" . ?l)))

;; 此处为提高启动时的运行速度而设置，具体不知是如何实现的(参照子龙山人的设置)
 (setq tramp-ssh-controlmaster-options
        "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")
  ;; define the refile targets
  (defvar org-agenda-dir "" "gtd org files location")
  (setq-default org-agenda-dir "~/org-notes")
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
  ;; the %i would copy the selected text into the template
  ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
  ;;add multi-file journal
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
(global-set-key (kbd "C-c r") 'org-capture)
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
          ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"cocos2d-x\"")
          ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"LFY\"")
          ("W" "Weekly Review"
           ((stuck "") ;; review stuck projects as designated by org-stuck-projects
            (tags-todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
            ))))
;; 自定义agenda-view
(defun air-org-skip-subtree-if-priority (priority)
     "Skip an agenda subtree if it has a priority of PRIORITY.
   PRIORITY may be one of the characters ?A, ?B, or ?C."
     (let ((subtree-end (save-excursion (org-end-of-subtree t)))
           (pri-value (* 1000 (- org-lowest-priority priority)))
           (pri-current (org-get-priority (thing-at-point 'line t))))
       (if (= pri-value pri-current)
           subtree-end
         nil)))
(defun air-org-skip-subtree-if-habit ()
     "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
     (let ((subtree-end (save-excursion (org-end-of-subtree t))))
       (if (string= (org-entry-get nil "STYLE") "habit")
           subtree-end
         nil)))
(setq org-agenda-custom-commands
         '(("c" "Simple agenda view"
            ((tags "PRIORITY=\"A\""
                   ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                    (org-agenda-overriding-header "High-priority unfinished tasks:")))
             (agenda "")
             (alltodo ""
                      ((org-agenda-skip-function
                        '(or (air-org-skip-subtree-if-priority ?A)
                             (org-agenda-skip-if nil '(scheduled deadline))))))))))

;;Org-pomodoro 是一个番茄时间工作法的插件（更多关于这个工作法的信息可以在这里找到）.在 (require 'org-pomodoro) 后可以通过
;;Customize-group 来对其进行设置，包括不同休息种类的时长。
(require 'org-pomodoro)
(setq pomodoro-break-time 2)
(setq pomodoro-long-break-time 5)
(setq pomodoro-work-time 15)
(setq-default mode-line-format
              (cons '(pomodoro-mode-line-string pomodoro-mode-line-string)
                    mode-line-format))
;;(pomodoro-add-to-mode-line)

;;关于GTD中某一项目计时问题(参考：用Org-mode实践《奇特的一生》)
;;在*.org文件中，移到一个条目上，按Ctrl-c Ctrl-x Ctrl-i即可对该条目开始计时，Ctrl-c Ctrl-x Ctrl-o停止当前计时。如果在Agenda中，移到条目按I(大写)即可对该条目开始计时，O(大写)即可停止计时。
;; 加前缀(Ctrl-u)再按Ctrl-c Ctrl-x Ctrl-i，可快速查看最近计时项目，进行快速计时。
;;对每个TODO任务，按Ctrl-c Ctrl-q即可赋符Tag.
;;在Day Agenda中，按R(大写)可打开Clockreport，查看当日计时统计.
;;实现类似柳比歇夫“第一类工作”时间类似的统计，我写了下面这个函数(org-clock-sum-today-by-tags)。
;; 并把它绑定到Ctrl-c Ctrl-x t按键上。可在当前光标处插入对当天各个分类进行时间统计(代码中的include-tags变量包含了参与统计的tags，可自行更改)。默认的效果是将当天非零的各分类时间统计显示出来。
;;如果需要统计的是前一天的，可加前缀(Ctrl-u)；如果要指定时间范围，可加两次前缀(Ctrl-u Ctrl-u)。
;; used by org-clock-sum-today-by-tags
(defun filter-by-tags ()
   (let ((head-tags (org-get-tags-at)))
     (member current-tag head-tags)))

(defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
  (interactive "P")
  (let* ((timerange-numeric-value (prefix-numeric-value timerange))
         (files (org-add-archive-files (org-agenda-files)))
         (include-tags '("ACADEMIC" "ENGLISH" "SCHOOL"
                         "LEARNING" "OUTPUT" "OTHER"
			 "work" "home" "life" "labtop"))
         (tags-time-alist (mapcar (lambda (tag) `(,tag . 0)) include-tags))
         (output-string "")
         (tstart (or tstart
                     (and timerange (equal timerange-numeric-value 4) (- (org-time-today) 86400))
                     (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "Start Date/Time:"))
                     (org-time-today)))
         (tend (or tend
                   (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "End Date/Time:"))
                   (+ tstart 86400)))
         h m file item prompt donesomething)
    (while (setq file (pop files))
      (setq org-agenda-buffer (if (file-exists-p file)
                                  (org-get-agenda-file-buffer file)
                                (error "No such file %s" file)))
      (with-current-buffer org-agenda-buffer
        (dolist (current-tag include-tags)
          (org-clock-sum tstart tend 'filter-by-tags)
          (setcdr (assoc current-tag tags-time-alist)
                  (+ org-clock-file-total-minutes (cdr (assoc current-tag tags-time-alist)))))))
    (while (setq item (pop tags-time-alist))
      (unless (equal (cdr item) 0)
        (setq donesomething t)
        (setq h (/ (cdr item) 60)
              m (- (cdr item) (* 60 h)))
        (setq output-string (concat output-string (format "[-%s-] %.2d:%.2d\n" (car item) h m)))))
    (unless donesomething
      (setq output-string (concat output-string "[-Nothing-] Done nothing!!!\n")))
    (unless noinsert
        (insert output-string))
    output-string))
(global-set-key (kbd "C-c C-x t") 'org-clock-sum-today-by-tags)

(org-babel-do-load-languages
    'org-babel-load-languages '((emacs-lisp . t)))

;; I open my gtd file when I hit C-c g
(defvar org-gtd-file (concat  "D:/Emacs/org-notes/gtd.org"))
(defun gtd ()
  "Open the GTD file."
  (interactive)
  (find-file org-gtd-file))
(global-set-key (kbd "C-c g")  'gtd)


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
;; Occur 可以用于显示变量或函数的定义，我们可以通过 popwin 的 customize-group 将定义显示设置为右边而不是默认的底部（ customize-group > popwin > ;;Popup Window Position 设置为 right），也可以在这里对其宽度进行调节。
;; Occur 与普通的搜索模式不同的是，它可以使用 Occur-Edit Mode (在弹出的窗口中按 e 进入编辑模式) 对搜索到的结果进行之间的编辑。
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

;; 在Company-mode中，默认使用M-n M-p来上下移动光标选择，下面设置后，用 C-n 与 C-p 来移动选择补全项
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
;;Emacs 就会将其自动展开成为我们所需要的字符串。可以自定义自已想用的一些词缩写。

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

;;ag它是非常快速的命令 行搜索工具，它是 Linux 的所有搜索工具中最快的。使用 ag 前我们需要进行安装，
;;# Windows 下通过 msys2 安装（确保在 path 中）
;;pacman -S mingw-w64-i686-ag # 32 位电脑
;;pacman -S mingw-w64-x86_64-ag # 64 位电脑
;;安装好 ag 后我们就可以安装 helm-ag 插件了。在安装完成后可以为其设置快捷键，
;;下面配置未成功
;;(require 'helm-ag)
;; (global-set-key (kbd "C-c p s") 'helm-do-ag-project-root)

;;写博客
;;(require 'org-octopress)
;;(setq org-octopress-directory-top       "~/Lfy_Study/octopress/source")
;;(setq org-octopress-directory-posts     "~/Lfy_Study/octopress/source/_posts")
;;(setq org-octopress-directory-org-top   "~/Lfy_Study/octopress/source")
;;(setq org-octopress-directory-org-posts "~/Lfy_Study/octopress/source/blog")
;;(setq org-octopress-setup-file          "~/Lfy_Study/setupfile.org")

;;查看git状态，在init.el中添加快捷键绑定
;;设置magit快捷键
(global-set-key (kbd "C-x g") 'magit-status)


;;友道词典配置
;; Enable Cache
(setq url-automatic-caching t)
;; Example Key binding
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point)
;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
;;(push "*Youdao Dictionary*" popwin:special-display-config)
;; Set file path for saving search history
(setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")
;; Enable Chinese word segmentation support (支持中文分词)
(setq youdao-dictionary-use-chinese-word-segmentation t)

;;time-stamp在此文件头部设置时间标志，每次文件修改保存时，时间自动更新
(setq time-stamp-line-limit 10) ; check first 10 buffer lines for Time-stamp: <>
(add-hook 'write-file-hooks 'time-stamp)
;;设置time-stamp格式
;;说明：
;;%:u，更新时用系统登录的用户名替换
;;%04y-%02m-%02d，更新时以“YYYY-MM-DD”的格式显示年月日
;;%02H:%02M:%02S，更新时以“HH:MM:SS”的格式显示时分秒
(setq time-stamp-format
      "此文件由 %:u 修改--最后修改时间为：%04y年%02m月%02d日 %02H时%02M分%02S秒"
      time-stamp-active t
      time-stamp-warn-inactive t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.08)
 '(company-minimum-prefix-length 1)
 '(org-pomodoro-length 50)
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Microsoft YaHei Mono" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
