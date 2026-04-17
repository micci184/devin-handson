import { Toaster } from "sonner";

import "./globals.css";

import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Devin Task Board",
  description: "リッチなタスク管理アプリ",
};

const RootLayout = ({ children }: { children: React.ReactNode }) => {
  return (
    <html lang="ja">
      <body>
        {children}
        <Toaster richColors position="top-right" />
      </body>
    </html>
  );
};
export default RootLayout;
