import { Button } from "@/components/ui/button";
import { useUser } from "@/hooks/use-user";
import {
  LayoutDashboard,
  CircleDollarSign,
  BarChart3,
  LogOut,
} from "lucide-react";

export function Sidebar() {
  const { user, logout } = useUser();

  return (
    <div className="w-64 border-r bg-card">
      <div className="p-6 space-y-4">
        <div className="flex items-center space-x-2">
          <CircleDollarSign className="h-6 w-6" />
          <h2 className="text-lg font-bold">SOLVY</h2>
        </div>
        
        <div className="space-y-1">
          <Button variant="ghost" className="w-full justify-start">
            <LayoutDashboard className="mr-2 h-4 w-4" />
            Dashboard
          </Button>
          <Button variant="ghost" className="w-full justify-start">
            <BarChart3 className="mr-2 h-4 w-4" />
            Analytics
          </Button>
        </div>
      </div>

      <div className="absolute bottom-0 p-6 w-64 border-t">
        <div className="flex items-center justify-between">
          <span className="font-medium">{user?.username}</span>
          <Button variant="ghost" size="icon" onClick={() => logout()}>
            <LogOut className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </div>
  );
}
