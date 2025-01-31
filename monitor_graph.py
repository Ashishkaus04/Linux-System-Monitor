import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.animation as animation

CSV_FILE = "system_usage.csv"

def update_graph(i):
    try:
        df = pd.read_csv(CSV_FILE)
        df["Timestamp"] = pd.to_datetime(df["Timestamp"])
        
        plt.clf()  # Clear previous graph
        
        plt.subplot(3, 1, 1)
        plt.plot(df["Timestamp"], df["CPU (%)"], marker="o", linestyle="-", color="r", label="CPU Usage")
        plt.axhline(y=80, color="r", linestyle="--", label="Threshold (80%)")
        plt.ylabel("CPU (%)")
        plt.legend()
        
        plt.subplot(3, 1, 2)
        plt.plot(df["Timestamp"], df["Memory (%)"], marker="o", linestyle="-", color="b", label="Memory Usage")
        plt.axhline(y=80, color="r", linestyle="--", label="Threshold (80%)")
        plt.ylabel("Memory (%)")
        plt.legend()
        
        plt.subplot(3, 1, 3)
        plt.plot(df["Timestamp"], df["Disk (%)"], marker="o", linestyle="-", color="g", label="Disk Usage")
        plt.axhline(y=80, color="r", linestyle="--", label="Threshold (80%)")
        plt.xlabel("Time")
        plt.ylabel("Disk (%)")
        plt.legend()
        
        plt.xticks(rotation=45)
        plt.tight_layout()
    
    except Exception as e:
        print(f"Error reading CSV: {e}")

# Set up animation to refresh every 5 seconds
fig = plt.figure(figsize=(10, 6))
ani = animation.FuncAnimation(fig, update_graph, interval=5000)

plt.show()
