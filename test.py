import tensorflow as tf
with tf.Session() as sess:
      with tf.device("/cpu:0"):
              matrix1 = tf.constant([[1., 2.], [3., 4.]])
              print(matrix1)
              print(sess.run(matrix1))
                  
