package com.example.fitness.ui
import android.app.Application; import androidx.lifecycle.AndroidViewModel; import androidx.lifecycle.viewModelScope
import com.example.fitness.data.WorkoutDatabase; import com.example.fitness.data.WorkoutRepository; import com.example.fitness.model.Workout
import kotlinx.coroutines.launch

class TrackerViewModel(application: Application) : AndroidViewModel(application) {
    private val repository = WorkoutRepository(WorkoutDatabase.getDatabase(application).dao())
    val allWorkouts = repository.allWorkouts; val totalSteps = repository.totalSteps

    fun addWorkout(steps: Int, calories: Int, duration: Int, date: Long) {
        viewModelScope.launch { repository.insert(Workout(steps = steps, calories = calories, duration = duration, date = date)) }
    }
}
