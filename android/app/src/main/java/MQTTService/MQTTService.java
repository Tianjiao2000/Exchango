package MQTTService;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import androidx.core.app.NotificationCompat;

public class MQTTService extends Service {

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startMyOwnForeground();
        } else {
            startForeground(1, new Notification());
        }

        // 初始化MQTT连接（这里可以通过JNI与Flutter的Dart代码交互）

        return START_STICKY;
    }

    private void startMyOwnForeground(){
        String NOTIFICATION_CHANNEL_ID = "com.example.yourapp.mqtt";
        String channelName = "MQTT Background Service";
        NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_MIN);
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        manager.createNotificationChannel(chan);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
        Notification notification = notificationBuilder.setOngoing(true)
            .setContentTitle("MQTT Service Running")
            .setPriority(NotificationManager.IMPORTANCE_MIN)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build();
        startForeground(2, notification);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null; // 服务不提供绑定
    }
}
