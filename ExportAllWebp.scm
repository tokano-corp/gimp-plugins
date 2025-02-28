(define (script-fu-export-all-images-webp quality)
  (let* (
         (image-ids (cadr (gimp-image-list))) ; Retrieve opened images IDs
         (image-list (if (vector? image-ids) (vector->list image-ids) '())) ; Convert to list
        )

    (define (replace-extension filename new-ext) ; Replace extension
      (let* ((dot-index (string-length filename))
         (dot-index (let loop ((i (- dot-index 1)))
                      (if (or (= i -1) (char=? (string-ref filename i) #\.))
                          i
                          (loop (- i 1))
                      )
                    )
         )
         (base-name (substring filename 0 dot-index)))
        (string-append base-name new-ext)
      )
    )

    (define (export-image image)
      (let* (
             (basename (car (gimp-image-get-filename image))) ; Retrieve image path and name
             (filename (replace-extension basename ".webp"))   ; Replace extension with .webp
             (width (car (gimp-image-width image))) ; Retrieve image width
             (height (car (gimp-image-height image))) ; Retrieve image height
             (drawable (car (gimp-image-merge-visible-layers image 0))) ; Merge all layers
            )
        ; Resize the merged layer to match the canvas size
        (gimp-layer-resize-to-image-size drawable)
        ; Export image in WebP format with chosen quality
        (file-webp-save 1 image drawable filename filename 0 0 quality 100 0 0 0 0 0 0 0 0 0)
      )
    )
    
    ; Export each image
    (for-each export-image image-list)
  )
)

; Save script
(script-fu-register "script-fu-export-all-images-webp"
  "Export All Images as WEBP"
  "Export all opened images as WEBP with chosen quality"
  "Tokano"
  "Copyright 2025, Tokano"
  "January 03, 2025"
  "*"
  SF-ADJUSTMENT "Quality" '(60 0 100 1 1 0 0) ;  Ajout du paramètre de qualité
)
; Add option to menu
(script-fu-menu-register "script-fu-export-all-images-webp" "<Image>/File/Export")
