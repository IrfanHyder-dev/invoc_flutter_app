//package com.invoc;
//
//import android.animation.Animator;
//import android.content.Context;
//import android.graphics.Typeface;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.text.Spannable;
//import android.text.SpannableString;
//import android.text.SpannableStringBuilder;
//import android.text.Spanned;
//import android.text.style.TypefaceSpan;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.widget.TextView;
//
//import androidx.annotation.LayoutRes;
//import androidx.annotation.NonNull;
//import androidx.annotation.Nullable;
//import androidx.core.content.res.ResourcesCompat;
//
//import io.flutter.Log;
////import io.flutter.embedding.android.SplashScreen;
//import androidx.core.splashscreen.SplashScreen;
//public class InvocSplash implements SplashScreen {
//    private final int resId;
//    private final long crossfadeDurationInMillis;
//    private View splashView;
//
//    public InvocSplash(@LayoutRes int resId) {
//        this(resId,500);
//    }
//
//    public InvocSplash(@NonNull int resId, @NonNull long crossfadeDurationInMillis) {
//        this.resId = resId;
//        this.crossfadeDurationInMillis = crossfadeDurationInMillis;
//    }
//
//    @Nullable
//    @Override
//    public View createSplashView(@NonNull Context context, @Nullable Bundle savedInstanceState) {
//        splashView = LayoutInflater.from(context).inflate(resId,null,false);
//        ((TextView)splashView.findViewById(R.id.slogan)).setText(getTitleText(context),TextView.BufferType.SPANNABLE);
//        return splashView;
//    }
//
//    @Override
//    public void transitionToFlutter(@NonNull Runnable onTransitionComplete) {
//        if (splashView == null) {
//            onTransitionComplete.run();
//            return;
//        }
//        Handler handler = new Handler(Looper.getMainLooper());
//        final Runnable runnable = new Runnable() {
//            @Override
//            public void run() {
//                splashView
//                        .animate()
//                        .alpha(0.0f)
//                        .setDuration(crossfadeDurationInMillis)
//                        .setListener(new Animator.AnimatorListener() {
//                            @Override
//                            public void onAnimationStart(Animator animation) {
//
//                            }
//
//                            @Override
//                            public void onAnimationEnd(Animator animation) {
//                                onTransitionComplete.run();
//                            }
//
//                            @Override
//                            public void onAnimationCancel(Animator animation) {
//                                onTransitionComplete.run();
//                            }
//
//                            @Override
//                            public void onAnimationRepeat(Animator animation) {
//
//                            }
//                        });
//            }
//        };
//
////        splashView
////                .animate()
////                .alpha(0.0f)
////                .setDuration(crossfadeDurationInMillis)
////                .setListener(
////                        new Animator.AnimatorListener() {
////                            @Override
////                            public void onAnimationStart(Animator animation) {}
////
////                            @Override
////                            public void onAnimationEnd(Animator animation) {
////                                handler.postDelayed(runnable,2000);
////                            }
////
////                            @Override
////                            public void onAnimationCancel(Animator animation) {
////                                handler.postDelayed(runnable,2000);
////                            }
////
////                            @Override
////                            public void onAnimationRepeat(Animator animation) {}
////                        });
//        handler.postDelayed(runnable,2000);
//
//    }
//
//    private SpannableStringBuilder getTitleText(Context context){
//
////        SpannableString spannableString = new SpannableString(" Scan \n & Compare\n Your food");
////        int len = spannableString.length();
//        Typeface typefaceBold = ResourcesCompat.getFont(context,R.font.poppins_bold);
//        Typeface typefaceLight = ResourcesCompat.getFont(context,R.font.poppins_extra_light);
//
//        TypefaceSpan typefaceSpanBold = new CustomTypefaceSpan("",typefaceBold);
//        TypefaceSpan typefaceSpanLight = new CustomTypefaceSpan("",typefaceLight);
//
////        spannableString.setSpan(typefaceSpanBold,1,2, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
////        spannableString.setSpan(typefaceSpanLight,5,7,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
////        spannableString.setSpan(typefaceSpanBold,8,16,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
////        spannableString.setSpan(typefaceSpanLight,17,len,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//        SpannableStringBuilder builder = new SpannableStringBuilder();
//        builder.append(customSpan(new CustomTypefaceSpan("",typefaceBold)," " + context.getString(R.string.scan)+" \n"));
//        builder.append(customSpan(new CustomTypefaceSpan("",typefaceLight)," & "));
//        builder.append(customSpan(new CustomTypefaceSpan("",typefaceBold),context.getString(R.string.compare) +"\n"));
//        builder.append(customSpan(new CustomTypefaceSpan("",typefaceLight)," "+context.getString(R.string.your_food)));
//        return builder;
//
//    }
//
//
//    private SpannableString customSpan(TypefaceSpan typefaceSpan, String text){
//
//        SpannableString spannableString = new SpannableString(text);
//        spannableString.setSpan(typefaceSpan,0,spannableString.length(),Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//
//        return spannableString;
//
//    }
//}
