<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $products = Product::when($request->category_id, function ($query) use ($request){
            return $query->where('category_id', $request->category_id);
        })->get();

        $products->load('category');

        return response()->json([
            'status' => 'success',
            'data' => $products
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'price' => 'required|integer',
            'stock' => 'required|integer',
            'category_id' => 'required|exists:categories,id',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        $data = $request->all();
        if($request->hasFile('image')){
            $path = $request->file('image')->store('products', 'public');
            $data['image'] = $path;
        }

        $products = Product::create($data);

         return response()->json([
            'status' => 'success',
            'data' => $products
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         $products = Product::findOrFail($id);
        $products->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Product deleted successfully'
        ]);

    }
}
