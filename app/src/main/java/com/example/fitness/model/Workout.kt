package com.example.fitness.model
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "workouts")
data class Workout(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val steps: Int,
    val calories: Int,
    val duration: Int,
    val date: Long
)
