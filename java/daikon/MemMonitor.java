package daikon;

import java.io.*;
import java.lang.Runtime;

public class MemMonitor implements Runnable {

  PrintWriter fout;

  boolean keep_going;
  long max_mem_usage;
  String filename;

  public MemMonitor(String fileName) {
    filename = fileName;
    try {
      fout = new PrintWriter(new BufferedWriter(new FileWriter(fileName)));
    } catch (java.io.IOException e) {
      System.out.println("could not open " + fileName);
    }

    keep_going = true;
    max_mem_usage = 0;

    long initial_mem_load = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
    fout.println("Initial memory load, " + initial_mem_load);
    fout.println("Format: pptName, peak_mem_usage, num_samples, num_static_vars, num_orig_vars, num_scalar_vars, num_array_vars, num_derived_scalar_vars, num_derived_array_vars");
    fout.close();
  }

  public void run() {
    while (keep_going) {
      long cur_mem_usage = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
      max_mem_usage = (max_mem_usage>cur_mem_usage) ? max_mem_usage : cur_mem_usage;
    }

    fout.close();
  }

  public void end_of_iteration(String pptName, int num_samples, int num_static_vars, int num_orig_vars, int num_scalar_vars, int num_array_vars, int num_derived_scalar_vars, int num_derived_array_vars) {

    try {
      fout = new PrintWriter(new BufferedWriter(new FileWriter(filename, true)));
    } catch (java.io.IOException e) {
      System.out.println("could not open " + filename);
    }

    fout.print(pptName + ", " + max_mem_usage + ", " + num_samples + ", ");
    fout.print(num_static_vars + ", " + num_orig_vars + ", " + num_scalar_vars + ", ");
    fout.println(num_array_vars + ", " + num_derived_scalar_vars + ", " + num_derived_array_vars);

    max_mem_usage = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
    fout.close();
  }

  public void stop() {
    keep_going = false;
  }
}
