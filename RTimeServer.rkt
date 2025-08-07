#lang racket/gui


;; =====================================================================
;; ============================== 主窗口 ===============================
;; =====================================================================
(define frame (new frame%
                   [label "rtimeserver - PTP Time Server"]
                   [width 800]
                   [height 600]
                   [style '(no-resize-border)]))

;; 最外层为水平布局，左侧导航，右侧内容
(define main-panel (new horizontal-panel%
                        [parent frame]
                        [spacing 5]
                        [border 5]))

(define nav-panel (new vertical-panel%
                       [parent main-panel]
                       [min-width 120]
                       [spacing 5]
                       [border 5]))

(define content-panel (new vertical-panel%
                           [parent main-panel]
                           [spacing 5]
                           [border 5]))


;; ======================================================================
;; ============================ 左侧导航面板 =============================
;; ======================================================================
;; 当前选中的导航栏
(define current-selection 0)

;; 创建导航按钮的函数
(define (create-nav-button label index)
  (new button%
       [parent nav-panel]
       [label label]
       [min-width 120]
       [min-height 30]
       [stretchable-width #f]
       [stretchable-height #f]
       [callback (lambda (button event)
                   (switch-to-panel index)
                   (update-nav-buttons index))]))

;; 导航按钮列表
(define nav-buttons '())

;; 创建导航按钮
(define nav-btn-1 (create-nav-button "⚙️参数设置" 0))
(define nav-btn-2 (create-nav-button "📊  状态监控" 1))
(define nav-btn-3 (create-nav-button "📝  日志输出" 2))
(define nav-btn-4 (create-nav-button "🔧  系统设置" 3))

(set! nav-buttons (list nav-btn-1 nav-btn-2 nav-btn-3 nav-btn-4))


;; ======================================================================
;; ======================= 右侧内容面板 ==================================
;; ======================================================================
;; 所有内容面板的列表
(define content-panels '())

;; =============== 时间输出面板 ====================
(define config-content-panel (new vertical-pane% [parent content-panel]))

;; 统一控件宽度
(define *input-width* 180)
(define *label-width* 90)

(define main-config-group (new group-box-panel%
                               [label "参数配置"]
                               [parent config-content-panel]
                               [stretchable-height #f]
                               [spacing 5]))

;; row1: 包含两个控件组(左和右)
(define row1 (new horizontal-panel%
                  [parent main-config-group]
                  [stretchable-height #f]
                  [spacing 40])) ; 控制两列之间的间距

;; 左列
(define left-panel1 (new horizontal-panel% [parent row1] [stretchable-width #t] [spacing 0]))
(define work-mode-label (new message% 
                             [parent left-panel1] 
                             [label "工作模式配置:"]
                             [stretchable-width #f]))
(define work-mode-choice (new choice%
                              [label " "]
                              [choices '("IEEE802.3" "UDPV4" "UDPV4+IEEE802.3")]
                              [parent left-panel1]
                              [selection 0]
                              [min-width *input-width*]
                              [stretchable-width #f]))

;; 右列
(define right-panel1 (new horizontal-panel% [parent row1] [stretchable-width #t] [spacing 0]))
(define profile-label (new message% 
                           [parent right-panel1] 
                           [label "Profile:"]
                           [stretchable-width #f]))
(define profile-choice (new choice%
                            [label ""]
                            [choices '("PTPV2" "gPTP")]
                            [parent right-panel1]
                            [selection 1]
                            [min-width *input-width*]
                            [stretchable-width #f]))

;; row2
(define row2 (new horizontal-panel%
                  [parent main-config-group]
                  [stretchable-height #f]
                  [spacing 40]))
;; 左列
(define left-panel2 (new horizontal-panel% [parent row2] [stretchable-width #t] [spacing 0]))
(define doamin-label (new message%
                          [parent left-panel2]
                          [label "Domain编号:"]
                          [stretchable-width #f]))
(define domain-field (new text-field%
                          [label ""]
                          [parent left-panel2]
                          [min-width *input-width*]
                          [init-value "0"]))

;; 右列
(define right-panel2 (new horizontal-panel% [parent row2] [stretchable-width #t] [spacing 0]))
(define announce-label (new message%
                            [parent right-panel2]
                            [label "Announce发送周期:"]
                            [stretchable-width #f]))
(define announce-filed (new text-field%
                            [label ""]
                            [parent right-panel2]
                            [min-width *input-width*]
                            [init-value "1"]))


;; ============ 状态监控面板 ==========================
(define status-content-panel (new vertical-pane% [parent content-panel]))




;; ============ 日志输出面板 ==========================
(define log-content-panel (new vertical-pane% [parent content-panel]))



;; ============ 系统设置面板 ==========================
(define settings-panel (new vertical-panel% [parent content-panel]))

(define (switch-to-panel index)
  (set! current-selection index)
  (for ([panel content-panels])
    (send panel show #f))
  (when (< index (length content-panels))
    (send (list-ref content-panels index) show #t)))

(define (update-nav-buttons selected-index)
  (for ([btn nav-buttons]
        [i (in-naturals)])
    (if (= i selected-index)
        (send btn enable #f)
        (send btn enable #t))))

(switch-to-panel 0)
(update-nav-buttons 0)

(send frame center)
(send frame show #t)