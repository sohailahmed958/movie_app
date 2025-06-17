// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    // Kotlin DSL uses 'val' for variables and direct property access instead of 'ext.'
    // Also, 'dependencies' block uses 'classpath()' instead of 'classpath' strings
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Define Kotlin version as a variable
        val kotlin_version by extra("1.8.0") // Or '1.9.0' as suggested, or higher
        classpath("com.android.tools.build:gradle:7.3.0") // Or a compatible version like 8.1.0 or newer
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral() // Corrected: changed 'mavenCenter()' to 'mavenCentral()'
    }
}

// Custom build directory for consistent structure
// Kotlin DSL uses 'layout.buildDirectory.dir' for paths
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir) // Use .set() for Provider properties

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir) // Use .set() for Provider properties

    // Crucial Fix: Force compileSdkVersion and targetSdkVersion for all Android subprojects (plugins included)
    afterEvaluate {
        // Use 'if (project.plugins.hasPlugin("android") || project.plugins.hasPlugin("android-library"))'
        // and 'project.extensions.getByType(com.android.build.gradle.BaseExtension::class.java)' to configure android block
        if (project.plugins.hasPlugin("android") || project.plugins.hasPlugin("android-library")) {
            val androidExtension = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            androidExtension.apply {
                compileSdkVersion(34) // Use function call syntax in Kotlin DSL
                defaultConfig {
                    targetSdkVersion(34) // Use function call syntax
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory.get()) // .get() to get the actual directory path
}


//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
//rootProject.layout.buildDirectory.value(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.value(newSubprojectBuildDir)
//}
//subprojects {
//    project.evaluationDependsOn(":app")
//}
//
//tasks.register<Delete>("clean") {
//    delete(rootProject.layout.buildDirectory)
//}
