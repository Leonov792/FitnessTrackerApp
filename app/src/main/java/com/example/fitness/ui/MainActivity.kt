package com.example.fitness.ui
import android.os.Bundle; import android.view.LayoutInflater; import android.view.ViewGroup; import android.widget.EditText; import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity; import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager; import androidx.recyclerview.widget.RecyclerView
import com.example.fitness.databinding.ActivityMainBinding; import com.example.fitness.databinding.ItemWorkoutBinding
import com.example.fitness.model.Workout; import com.google.android.material.dialog.MaterialAlertDialogBuilder

class MainActivity : AppCompatActivity() {
    private lateinit var b: ActivityMainBinding; private lateinit var vm: TrackerViewModel
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState); b = ActivityMainBinding.inflate(layoutInflater); setContentView(b.root)
        vm = ViewModelProvider(this)[TrackerViewModel::class.java]; b.rvWorkouts.layoutManager = LinearLayoutManager(this)
        vm.workouts.observe(this) { list ->
            b.rvWorkouts.adapter = Adapter(list)
            val totalSteps = list.sumOf { it.steps }
            b.tvSteps.text = totalSteps.toString()
            b.tvCalories.text = (totalSteps * 0.04).toInt().toString()
            b.tvDistance.text = String.format("%.1f", totalSteps * 0.0008)
        }
        b.btnAdd.setOnClickListener { showDialog() }
    }
    private fun showDialog() {
        val steps = EditText(this).apply { hint = "Шаги" }
        val mins = EditText(this).apply { hint = "Минуты" }
        val layout = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; addView(steps); addView(mins) }
        MaterialAlertDialogBuilder(this).setTitle("Добавить тренировку").setView(layout)
            .setPositiveButton("OK") { _, _ -> val s = (steps.text.toString().toIntOrNull() ?: 0); val m = (mins.text.toString().toIntOrNull() ?: 0)
                if (s > 0) vm.add(s, m) }
            .setNegativeButton("Отмена", null).show()
    }
    inner class Adapter(private val items: List<Workout>) : RecyclerView.Adapter<Adapter.VH>() {
        inner class VH(val b: ItemWorkoutBinding) : RecyclerView.ViewHolder(b.root)
        override fun onCreateViewHolder(p: ViewGroup, t: Int) = VH(ItemWorkoutBinding.inflate(LayoutInflater.from(p.context), p, false))
        override fun onBindViewHolder(h: VH, i: Int) { val w = items[i]; h.b.tvSteps.text = "${w.steps} шагов"; h.b.tvCalories.text = "${(w.steps * 0.04).toInt()} ккал" }
        override fun getItemCount() = items.size
    }
}
