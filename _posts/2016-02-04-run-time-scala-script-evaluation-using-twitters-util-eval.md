---
layout: post
title: Run Time Scala Script Evaluation Using Twitter's Util-eval
modified:
categories:
excerpt: Dynamically Evaluating scala code using Twitter's util-eval. makes it easier to run Dynamic code and even enable plug and play like features into your application. Must be careful as this also introduces a whole new level of security threat. As the Dynamic Code can be anything.
tags: [ Scala, util-eval, twitter, maven,dynaimc code, runtime Execution]
image:
  feature:
date: 2016-02-04T10:59:45+05:30
---

Twitter's Eval can be used to Dynamically compile and use the Code in your application thus making it very effective for Dynamic Programming.

#### Maven Dependency

Mvnrepository

- [util-eval Scala 2.11](http://mvnrepository.com/artifact/com.twitter/util-eval_2.11)
- [util-eval Scala 2.10](http://mvnrepository.com/artifact/com.twitter/util-eval_2.10)

{% highlight xml %}
<dependency>
    <groupId>com.twitter</groupId>
    <artifactId>util-eval_${scala-minor.version}</artifactId>
    <version>${twitter-util-eval.version}</version>
</dependency>
{% endhighlight%}



The Eval Function evaluates files, strings, or input streams as Scala code, and returns the result.

{% highlight scala %}
val eval = new Eval(target : scala.Option[java.io.File])
{% endhighlight%}

The eval function takes a single parameter Target. If the target is None, the results are compiled to memory (and are therefore ephemeral). If target is Some(path), the path must point to a directory, and classes will be saved into that directory.


##### The flow of evaluation is:

- extract a string of code from the file, string, or input stream
- run preprocessors on that string
- wrap processed code in an apply method in a generated class
- compile the class
- contruct an instance of that class
- return the result of apply()


#### Declare an Interface which your Dynamic Code should Follow

For the Example I've declared a variable name and a function orderString in my trait.


{% highlight scala %}
package com.example

trait EvalInterface extends Serializable {
  val name:String
  def orderString(i: String): String
}
{% endhighlight%}

#### The Dynamic Code which would be evaluated at runtime

Saving the file in the location /path/tsv.scala

{% highlight scala %}
package com.example.EvalInterface
new EvalInterface {
  override val name:String="TSV"
  override def orderString(i: String): String = {
    i.splitBy(",").mkString("\t")
  }
}
{% endhighlight%}

Saving the file in the location /path/csv.scala

{% highlight scala %}
package com.example.EvalInterface
new EvalInterface {
  override val name:String="CSV"
  override def orderString(i: String): String = {
    i.splitBy(",").mkString(",")
  }
}
{% endhighlight%}

Now we can Load these files at runtime to execute the functions

#### The Dynamic Code Evaluation


{% highlight scala %}
package com.example

import com.twitter.util.Eval
import java.io.File

object EvalExample extends App {

val eval = new Eval // Initializing The Eval without any target location

val csvEval: EvalInterface = eval[EvalInterface](new File("/path/csv.scala"))

val tsvEval: EvalInterface = eval[EvalInterface](new File("/path/tsv.scala"))

val records = Array(
  "1,2,3,4,5",
  "9,8,7,6,5"
  )

println(csvEval.name)
records.foreach( i => println(csvEval.orderString( i )))
println(tsvEval.name)
records.foreach( i => println(tsvEval.orderString( i )))

}

{% endhighlight %}
