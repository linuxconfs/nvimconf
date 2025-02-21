;; extends
;; 选中整个函数，并包括上下的空行
; outer function textobject
(function_declaration body: (_)? @function.outercustome
  (#offset! @function.outercustome -1 0 1 0))
; (function_declaration body: (_)? @function.outer
;   (#offset! @function.outer -1 0 1 0))

;; 选中整个函数，并包括上下的空行
; outer function literals
(func_literal (_)?
  @function.outercustome
  (#offset! @function.outercustome -1 0 1 0))

; method as outer function textobject
(method_declaration
  body: (block)?
  @function.outercustome
  (#offset! @function.outercustome -1 0 1 0))
