import { Sidebar } from "@/components/dashboard/Sidebar";
import { MetricsCards } from "@/components/dashboard/MetricsCards";
import { TransactionList } from "@/components/dashboard/TransactionList";
import { TransactionChart } from "@/components/dashboard/TransactionChart";

export default function HomePage() {
  return (
    <div className="flex h-screen bg-background">
      <Sidebar />
      <main className="flex-1 p-6 overflow-auto">
        <div className="space-y-6">
          <h1 className="text-3xl font-bold">Dashboard</h1>
          <MetricsCards />
          <div className="grid gap-6 md:grid-cols-2">
            <TransactionChart />
            <TransactionList />
          </div>
        </div>
      </main>
    </div>
  );
}
