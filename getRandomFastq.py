ó
«ÿXc           @   s`   d  d l  Z  d   Z e  j j d  d  d l Te  j d Z e  j d Z e e e e   d S(   iÿÿÿÿNc         C   s  d d  l  } t |  d  } t t d t |  d |   d  } | j d d  | j   } i  } d } | j | d  | | } xö t |  | k  r|| | k  r|| j d |  }	 | j |	 d  | j   }
 | j   } x/ |
 d d !d	 k r| j   }
 | j   } qâ W|
 } | j   } | j   } | j   } | j |  | j |  | j |  | j |  d | | <q W| j	   | j	   d  S(
   Niÿÿÿÿt   rt   rand_t   _t   wi   i   i    s   @HWI(
   t   randomt   opent   strt   seekt   tellt   lent	   randranget   readlinet   writet   close(   t   fastqt   numReadsR   t   ft   gt   endt   idst   nbt   windowt   rbtt   linet   idt   readt   id2t   qual(    (    s5   /coppolalabshares/amrf/RNAseq-tools/getRandomFastq.pyt   getRandomFastq   s:    '
!

s)   /u/home/eeskin2/rkawaguc/PIPELINE/RNA-seq(   t   *i   i   (   t   sysR   t   patht   appendt   argvR   R   t   int(    (    (    s5   /coppolalabshares/amrf/RNAseq-tools/getRandomFastq.pyt   <module>   s   	
