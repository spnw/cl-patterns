;;; debug.lisp - the debug backend for cl-patterns.
;; this is just used to print incoming backend events, for debugging purposes.

(in-package #:cl-patterns)

(defmethod start-backend ((backend (eql :debug)))
  (format t "~&Starting debug backend (i.e. doing nothing).~%"))

(defmethod stop-backend ((backend (eql :debug)))
  (format t "~&Stopping debug backend (i.e. doing nothing).~%"))

(defmethod backend-plays-event-p (event (backend (eql :debug)))
  t)

(defparameter *debug-backend-events* (list)
  "A list of all events received by the debug backend, with the most recent events first.")

(defmethod backend-play-event (item task (backend (eql :debug)))
  (declare (ignore task))
  (format t "~&Debug: playing event: ~s~%" item)
  (push item *debug-backend-events*))

(defmethod backend-task-removed (task (backend (eql :debug)))
  (format t "~&Debug: task removed: ~s~%" task))

(defun debug-recent-events (&optional (n 10))
  "Get the N most recent events that the debug backend received."
  (loop :for i :in *debug-backend-events*
     :repeat n
     :collect i))

(export 'debug-recent-events)

(register-backend :debug)