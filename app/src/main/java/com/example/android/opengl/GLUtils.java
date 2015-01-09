package com.example.android.opengl;

import android.content.Context;
import android.opengl.GLES20;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class GLUtils {
    public static int createShader (int type, String src) {
        int shader = GLES20.glCreateShader(type);

        GLES20.glShaderSource(shader, src);
        checkGlError("Shader Source");
        GLES20.glCompileShader(shader);
        checkGlError("Shader Compile");
        return shader;
    }

    public static int createProgram (int vertexShader, int fragmentShader) {
        int program = GLES20.glCreateProgram();

        GLES20.glAttachShader(GLES20.GL_VERTEX_SHADER, vertexShader);
        GLES20.glAttachShader(GLES20.GL_FRAGMENT_SHADER, fragmentShader);
        GLES20.glLinkProgram(program);
        return program;
    }

    public static int programFromSrc (String vSrc, String fSrc) {
        int vertexShader = createShader(GLES20.GL_VERTEX_SHADER, vSrc);
        int fragShader   = createShader(GLES20.GL_FRAGMENT_SHADER, fSrc);
        int program      = createProgram(vertexShader, fragShader);

        return program;
    }

    public static String loadText (Context context, int resourceId) {
        InputStream is    = context.getResources().openRawResource(resourceId);
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        String thisLine   = null;
        String text       = "";

        try {
            while ((thisLine = br.readLine()) != null) {
                text += thisLine;
            }
            is.close();
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return text;
    }

    public void updateBuffer () {}

    public static void checkGlError(String glOperation) {
        int error;
        while ((error = GLES20.glGetError()) != GLES20.GL_NO_ERROR) {
            Log.e("BLOOP", glOperation + ": glError " + error);
            throw new RuntimeException(glOperation + ": glError " + error);
        }
    }
}