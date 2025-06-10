// supabase/functions/flow-coach-notifier/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  console.log("Function gestart");

  const supabaseClient = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const today = new Date().toISOString().split('T')[0];
  console.log("Datum:", today);

  let users, error;
  try {
    const result = await supabaseClient
      .from('daily_progress')
      .select('session_id, water_intake, planned_meals, planned_break')
      .eq('date', today);
    users = result.data;
    error = result.error;
  } catch (err) {
    console.error("Onverwachte fout bij ophalen van users:", err);
    return new Response("Database error", { status: 500 });
  }

  if (error) {
    console.error("Fout bij ophalen van users:", error.message);
    return new Response("Database error", { status: 500 });
  }

  console.log("Aantal users gevonden:", users?.length ?? 0);

  const notifications: { session_id: string; message: string }[] = [];

  for (const user of users || []) {
    if ((user.water_intake ?? 0) < 2) {
      notifications.push({ session_id: user.session_id, message: '💧 Vergeet je water niet vandaag!' });
    }
    if ((user.planned_meals ?? 0) < 2) {
      notifications.push({ session_id: user.session_id, message: '🥗 Nog geen lunch gepland vandaag?' });
    }
    if (!user.planned_break) {
      notifications.push({ session_id: user.session_id, message: '🧘 Tijd voor een korte pauze ingepland?' });
    }
  }

  for (const note of notifications) {
    console.log("Notificatie voor sessie", note.session_id, ":", note.message);
    try {
      await supabaseClient.from('flow_notifications').insert(note);
    } catch (err) {
      console.error("Fout bij toevoegen notificatie voor sessie", note.session_id, ":", err);
    }
  }

  return new Response(JSON.stringify({ status: 'done', count: notifications.length }), {
    headers: { 'Content-Type': 'application/json' },
  });
});