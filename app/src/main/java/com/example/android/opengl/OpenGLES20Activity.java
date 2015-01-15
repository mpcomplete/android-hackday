/*
 * Copyright (C) 2011 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.android.opengl;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

public class OpenGLES20Activity extends Activity implements AdapterView.OnItemSelectedListener {
    private ShaderToyRenderer.ShaderSpec[] shaders = new ShaderToyRenderer.ShaderSpec[]{
            new ShaderToyRenderer.ShaderSpec(R.raw.pirates, new int[]{R.drawable.tex03, R.drawable.tex16}),
            new ShaderToyRenderer.ShaderSpec(R.raw.clouds, new int[]{R.drawable.tex16}),
    };
    private GLSurfaceView mGLView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        for (int i = 0; i < shaders.length; ++i)
            shaders[i].fragmentSrc = GLUtils.loadText(this, shaders[i].fragmentSrcResource);
        mGLView = new MyGLSurfaceView(this, shaders[0]);
        setContentView(mGLView);
    }

    public boolean onCreateOptionsMenu (Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.activity_menu, menu);

        Spinner spinner = (Spinner) menu.getItem(0).getActionView().findViewById(R.id.spinner);
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < shaders.length; ++i)
            list.add("shader");
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this,
                android.R.layout.simple_spinner_item, list);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(dataAdapter);
        spinner.setOnItemSelectedListener(this);

        return super.onCreateOptionsMenu(menu);
    }

    public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
        mGLView = new MyGLSurfaceView(this, shaders[pos]);
        setContentView(mGLView);
    }

    public void onNothingSelected(AdapterView<?> parent) {
        // Another interface callback
    }

    @Override
    protected void onPause() {
        super.onPause();
        mGLView.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        mGLView.onResume();
    }
}