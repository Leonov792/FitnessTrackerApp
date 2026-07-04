package com.example.fitness.ui
import android.os.Bundle; import android.view.LayoutInflater; import android.view.ViewGroup; import android.widget.EditText; import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity; import androidx.lifecycle.ViewModelProvider; import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager; import androidx.recyclerview.widget.RecyclerView
import com.example.fitness.databinding.ActivityMainBinding; import com.example.fitness.databinding.ItemWorkoutBinding
import com.example.fitness.model.Workout; import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.coroutines.launch; import java.text.SimpleDateFormat; import java.util.Date; import java.util.Locale

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var viewModel: TrackerViewModel
    private lateinit var adapter: WorkoutAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater); setContentView(binding.root)
        viewModel = ViewModelProvider(this)[TrackerViewModel::class.java]
        adapter = WorkoutAdapter()
        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        binding.recyclerView.adapter = adapter
        lifecycleScope.launch { viewModel.totalSteps.collect { binding.stepsText.text = "Total Steps: ${it ?: 0}" } }
        lifecycleScope.launch { viewModel.allWorkouts.collect { adapter.submitList(it) } }
        binding.fab.setOnClickListener { showAddDialog() }
    }

    private fun showAddDialog() {
        val stepsInput = EditText(this).apply { hint = "Steps"; inputType = android.text.InputType.TYPE_CLASS_NUMBER }
        val calInput = EditText(this).apply { hint = "Calories"; inputType = android.text.InputType.TYPE_CLASS_NUMBER }
        val durInput = EditText(this).apply { hint = "Duration (min)"; inputType = android.text.InputType.TYPE_CLASS_NUMBER }
        val layout = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; addView(stepsInput); addView(calInput); addView(durInput) }
        MaterialAlertDialogBuilder(this)
            .setTitle("Add Workout").setView(layout)
            .setPositiveButton("Save") { _, _ ->
                val s = stepsInput.text.toString().toIntOrNull() ?: 0
                val c = calInput.text.toString().toIntOrNull() ?: 0
                val d = durInput.text.toString().toIntOrNull() ?: 0
                viewModel.addWorkout(s, c, d, System.currentTimeMillis())
            }.setNegativeButton("Cancel", null).show()
    }

    inner class WorkoutAdapter : RecyclerView.Adapter<WorkoutAdapter.VH>() {
        private var list = listOf<Workout>()
        fun submitList(newList: List<Workout>) { list = newList; notifyDataSetChanged() }
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = VH(ItemWorkoutBinding.inflate(LayoutInflater.from(parent.context), parent, false))
        override fun onBindViewHolder(holder: VH, position: Int) { holder.bind(list[position]) }
        override fun getItemCount() = list.size
        inner class VH(val b: ItemWorkoutBinding) : RecyclerView.ViewHolder(b.root) {
            fun bind(w: Workout) {
                b.steps.text = "Steps: ${w.steps}"; b.calories.text = "Calories: ${w.calories}"
                b.duration.text = "Duration: ${w.duration} min"
                b.date.text = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date(w.date))
            }
        }
    }
}
