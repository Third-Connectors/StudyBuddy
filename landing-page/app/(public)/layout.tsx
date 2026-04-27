export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col min-h-screen">
      {/* Anda bisa menambahkan Navbar/Footer di sini jika nanti diperlukan */}
      <main className="flex-grow">{children}</main>
    </div>
  );
}
