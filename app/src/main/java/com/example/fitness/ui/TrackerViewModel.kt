package com.example.fitness.ui
import android.app.Application; import androidx.lifecycle.AndroidViewModel; import androidx.lifecycle.LiveData; import androidx.lifecycle.viewModelScope
import com.example.fitness.data.WorkoutDatabase; import com.example.fitness.data.WorkoutRepository; import com.example.fitness.model.Workout; import kotlinx.coroutines.launch

class TrackerViewModel(application: Application) : AndroidViewModel(application) {
    private val repo = WorkoutRepository(WorkoutDatabase.getDatabase(application).dao())
    val workouts: LiveData<List<Workout>> = repo.allWorkouts
    fun add(steps: Int, duration: Int) = viewModelScope.launch {
        repo.insert(Workout(steps = steps, calories = (steps * 0.04).toInt(), duration = duration, date = System.currentTimeMillis()))
    }
}
