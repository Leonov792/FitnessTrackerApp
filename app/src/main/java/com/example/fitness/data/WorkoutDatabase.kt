package com.example.fitness.data
import android.content.Context; import androidx.room.*; import com.example.fitness.model.Workout

@Dao
interface WorkoutDao {
    @Query("SELECT * FROM workouts ORDER BY date DESC") fun getAll(): androidx.lifecycle.LiveData<List<Workout>>
    @Insert suspend fun insert(workout: Workout)
    @Query("SELECT SUM(steps) FROM workouts") fun getTotalSteps(): androidx.lifecycle.LiveData<Int?>
}

@Database(entities = [Workout::class], version = 1, exportSchema = false)
abstract class WorkoutDatabase : RoomDatabase() {
    abstract fun dao(): WorkoutDao
    companion object {
        @Volatile private var INSTANCE: WorkoutDatabase? = null
        fun getDatabase(context: Context): WorkoutDatabase = INSTANCE ?: synchronized(this) {
            Room.databaseBuilder(context.applicationContext, WorkoutDatabase::class.java, "workout_db").build().also { INSTANCE = it }
        }
    }
}

class WorkoutRepository(private val dao: WorkoutDao) {
    val allWorkouts = dao.getAll()
    val totalSteps = dao.getTotalSteps()
    suspend fun insert(workout: Workout) = dao.insert(workout)
}
